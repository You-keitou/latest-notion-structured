-- 3_add_inbox.sql

-- Inbox table for capturing unprocessed items
create table public.inbox_items (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    title text not null,
    content text,
    source text, -- 'manual', 'email', 'meeting', 'thought' など
    processed boolean default false,
    processed_at timestamp with time zone,
    processed_into text, -- 'action', 'project', 'reference', 'trash' など
    processed_item_id uuid, -- 処理後に作成されたitem（action/projectなど）のID
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null
);

-- Create enum for inbox item sources
create type inbox_source_enum as enum (
    'manual',
    'email',
    'meeting',
    'thought',
    'notion',
    'other'
);

-- Create enum for processed destinations
create type processed_destination_enum as enum (
    'action',
    'project',
    'reference',
    'someday_maybe',
    'trash'
);

-- Add constraints
alter table public.inbox_items
    add constraint valid_source
    check (source::inbox_source_enum is not null);

alter table public.inbox_items
    add constraint valid_processed_into
    check (processed_into::processed_destination_enum is not null or processed_into is null);

-- Enable RLS
alter table public.inbox_items enable row level security;

-- Inbox policies
create policy "Enable read access for own inbox items"
    on inbox_items for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own inbox items"
    on inbox_items for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own inbox items"
    on inbox_items for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own inbox items"
    on inbox_items for delete
    using (auth.uid() = user_id);

-- Add updated_at trigger
create trigger handle_updated_at
    before update on public.inbox_items
    for each row
    execute procedure public.handle_updated_at();

-- Add indexes
create index idx_inbox_items_user_id on public.inbox_items(user_id);
create index idx_inbox_items_processed on public.inbox_items(processed);
create index idx_inbox_items_created_at on public.inbox_items(created_at);

-- Function to process inbox item
create or replace function process_inbox_item(
    p_inbox_item_id uuid,
    p_destination processed_destination_enum,
    p_processed_item_id uuid
) returns void as $$
begin
    update public.inbox_items
    set processed = true,
        processed_at = now(),
        processed_into = p_destination,
        processed_item_id = p_processed_item_id,
        updated_at = now()
    where id = p_inbox_item_id
    and processed = false;
end;
$$ language plpgsql security definer;

-- Add stats function
create or replace function get_inbox_stats(p_user_id uuid)
returns table (
    total_items bigint,
    unprocessed_items bigint,
    processed_last_24h bigint,
    oldest_unprocessed_date timestamp with time zone
) as $$
begin
    return query
    select
        count(*)::bigint as total_items,
        count(*) filter (where not processed)::bigint as unprocessed_items,
        count(*) filter (where processed and processed_at > now() - interval '24 hours')::bigint as processed_last_24h,
        min(created_at) filter (where not processed) as oldest_unprocessed_date
    from public.inbox_items
    where user_id = p_user_id;
end;
$$ language plpgsql security definer;