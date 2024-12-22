-- 4_add_notion_sync.sql

-- Notion connection settings table
create table public.notion_connections (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    access_token text not null,
    workspace_id text,
    workspace_name text,
    last_successful_sync timestamp with time zone,
    is_active boolean default true,
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null,
    -- ユーザーごとに1つのコネクションのみ許可
    constraint unique_user_connection unique (user_id)
);

-- Notion sync states table
create table public.notion_sync_states (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    item_type text not null check (item_type in ('area', 'project', 'action')),
    local_id uuid not null,
    notion_id text not null,
    last_synced_at timestamp with time zone not null,
    last_notion_update timestamp with time zone,
    last_local_update timestamp with time zone,
    sync_status text not null default 'synced' check (sync_status in ('synced', 'pending_push', 'pending_pull', 'conflict')),
    error_message text,
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null
);

-- Notion sync logs table
create table public.notion_sync_logs (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    sync_type text not null,
    status text not null,
    started_at timestamp with time zone default now() not null,
    completed_at timestamp with time zone,
    items_processed integer default 0,
    error_message text,
    details jsonb
);

-- Enable RLS
alter table public.notion_connections enable row level security;
alter table public.notion_sync_states enable row level security;
alter table public.notion_sync_logs enable row level security;

-- Notion connections policies
create policy "Enable read access for own notion connections"
    on notion_connections for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own notion connections"
    on notion_connections for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own notion connections"
    on notion_connections for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own notion connections"
    on notion_connections for delete
    using (auth.uid() = user_id);

-- Similar policies for sync states and logs
create policy "Enable read access for own sync states"
    on notion_sync_states for select
    using (auth.uid() = user_id);

create policy "Enable all access for own sync states"
    on notion_sync_states for all
    using (auth.uid() = user_id);

create policy "Enable read access for own sync logs"
    on notion_sync_logs for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own sync logs"
    on notion_sync_logs for insert
    with check (auth.uid() = user_id);

-- Add updated_at triggers
create trigger handle_updated_at
    before update on public.notion_connections
    for each row
    execute procedure public.handle_updated_at();

create trigger handle_updated_at
    before update on public.notion_sync_states
    for each row
    execute procedure public.handle_updated_at();

-- Add indexes
create index idx_notion_sync_states_user_id on public.notion_sync_states(user_id);
create index idx_notion_sync_states_local_id on public.notion_sync_states(local_id);
create index idx_notion_sync_states_notion_id on public.notion_sync_states(notion_id);
create index idx_notion_sync_states_sync_status on public.notion_sync_states(sync_status);
create index idx_notion_sync_logs_user_id on public.notion_sync_logs(user_id);
create index idx_notion_sync_logs_started_at on public.notion_sync_logs(started_at);

-- Helper function for sync status update
create or replace function update_sync_status(
    p_user_id uuid,
    p_item_type text,
    p_local_id uuid,
    p_notion_id text,
    p_sync_status text,
    p_error_message text default null
) returns void as $$
begin
    insert into public.notion_sync_states (
        user_id,
        item_type,
        local_id,
        notion_id,
        last_synced_at,
        sync_status,
        error_message
    ) values (
        p_user_id,
        p_item_type,
        p_local_id,
        p_notion_id,
        now(),
        p_sync_status,
        p_error_message
    )
    on conflict (user_id, item_type, local_id) do update set
        sync_status = p_sync_status,
        error_message = p_error_message,
        last_synced_at = now(),
        updated_at = now();
end;
$$ language plpgsql security definer;

-- Function to get sync statistics
create or replace function get_sync_stats(p_user_id uuid)
returns table (
    total_items bigint,
    synced_items bigint,
    pending_items bigint,
    conflict_items bigint,
    last_successful_sync timestamp with time zone
) as $$
begin
    return query
    select
        count(*)::bigint as total_items,
        count(*) filter (where sync_status = 'synced')::bigint as synced_items,
        count(*) filter (where sync_status in ('pending_push', 'pending_pull'))::bigint as pending_items,
        count(*) filter (where sync_status = 'conflict')::bigint as conflict_items,
        max(last_synced_at) filter (where sync_status = 'synced') as last_successful_sync
    from public.notion_sync_states
    where user_id = p_user_id;
end;
$$ language plpgsql security definer;