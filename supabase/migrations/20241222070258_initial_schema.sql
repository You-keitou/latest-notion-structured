-- 1_initial_schema.sql

-- Enable RLS
create extension if not exists "uuid-ossp";

-- Areas table
create table public.areas (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    title text not null,
    notion_id text,
    is_archived boolean default false,
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null
);

-- Projects table
create table public.projects (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    area_id uuid references public.areas(id),
    title text not null,
    status text not null default 'active', -- active, completed, someday_maybe
    notion_id text,
    desired_outcome text,
    next_review_date date,
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null
);

-- RLS Policies
alter table public.areas enable row level security;
alter table public.projects enable row level security;

-- Areas policies
create policy "Enable read access for own areas"
    on areas for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own areas"
    on areas for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own areas"
    on areas for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own areas"
    on areas for delete
    using (auth.uid() = user_id);

-- Projects policies
create policy "Enable read access for own projects"
    on projects for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own projects"
    on projects for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own projects"
    on projects for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own projects"
    on projects for delete
    using (auth.uid() = user_id);

-- Updated at trigger function
create or replace function public.handle_updated_at()
returns trigger as $$
begin
    new.updated_at = now();
    return new;
end;
$$ language plpgsql;

-- Add triggers for updated_at
create trigger handle_updated_at
    before update on public.areas
    for each row
    execute procedure public.handle_updated_at();

create trigger handle_updated_at
    before update on public.projects
    for each row
    execute procedure public.handle_updated_at();