-- 2_add_actions.sql

-- Actions table
create table public.actions (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    project_id uuid references public.projects(id),
    title text not null,
    status text not null default 'next_action', -- next_action, waiting_for, completed
    notion_id text,
    context text, -- @home, @work, @computer など
    time_slot text, -- morning, afternoon, evening, night (Notionの「枠」と同期)
    scheduled_date date,
    start_time timestamp with time zone,
    end_time timestamp with time zone,
    is_masked boolean default false,
    is_pinned boolean default false,
    energy_level integer check (energy_level between 1 and 3),
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null
);

-- Action logs table for tracking completion history
create table public.action_logs (
    id uuid default uuid_generate_v4() primary key,
    action_id uuid references public.actions(id) on delete cascade not null,
    user_id uuid references auth.users on delete cascade not null,
    completed_at timestamp with time zone default now() not null,
    duration_minutes integer,
    created_at timestamp with time zone default now() not null
);

-- Enable RLS
alter table public.actions enable row level security;
alter table public.action_logs enable row level security;

-- Actions policies
create policy "Enable read access for own actions"
    on actions for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own actions"
    on actions for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own actions"
    on actions for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own actions"
    on actions for delete
    using (auth.uid() = user_id);

-- Action logs policies
create policy "Enable read access for own action logs"
    on action_logs for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own action logs"
    on action_logs for insert
    with check (auth.uid() = user_id);

-- Add updated_at trigger for actions
create trigger handle_updated_at
    before update on public.actions
    for each row
    execute procedure public.handle_updated_at();

-- Create enum for time_slot
create type time_slot_enum as enum (
    'morning',    -- 午前 08:00~12:00
    'afternoon',  -- 午後 12:00~16:00
    'evening',    -- 夕方 16:00~20:00
    'night'       -- 夜 20:00~24:00
);

-- Add constraint for time_slot
alter table public.actions
    add constraint valid_time_slot
    check (time_slot::time_slot_enum is not null);

-- Add indexes for better query performance
create index idx_actions_user_id on public.actions(user_id);
create index idx_actions_project_id on public.actions(project_id);
create index idx_actions_scheduled_date on public.actions(scheduled_date);
create index idx_actions_status on public.actions(status);
create index idx_action_logs_action_id on public.action_logs(action_id);
create index idx_action_logs_user_id on public.action_logs(user_id);