-- 5_add_weekly_review.sql

-- Weekly Review table
create table public.weekly_reviews (
    id uuid default uuid_generate_v4() primary key,
    user_id uuid references auth.users on delete cascade not null,
    review_date date not null,
    status text not null default 'in_progress' check (status in ('in_progress', 'completed', 'skipped')),

    -- Review checklist
    inbox_cleared boolean default false,
    areas_reviewed boolean default false,
    projects_reviewed boolean default false,
    actions_reviewed boolean default false,
    someday_maybe_reviewed boolean default false,
    calendar_reviewed boolean default false,

    -- Review details
    inbox_processed_count integer default 0,
    projects_updated_count integer default 0,
    actions_completed_count integer default 0,
    actions_added_count integer default 0,

    -- Review insights
    wins text[], -- 今週の成功
    challenges text[], -- 直面した課題
    next_week_focus text, -- 来週の焦点

    notes text,
    started_at timestamp with time zone default now(),
    completed_at timestamp with time zone,
    created_at timestamp with time zone default now() not null,
    updated_at timestamp with time zone default now() not null,

    -- 週ごとに1つのレビューのみ許可
    constraint unique_weekly_review unique (user_id, review_date)
);

-- Review action items table
create table public.review_action_items (
    id uuid default uuid_generate_v4() primary key,
    review_id uuid references public.weekly_reviews on delete cascade not null,
    user_id uuid references auth.users on delete cascade not null,
    item_type text not null check (item_type in ('project', 'action', 'someday_maybe')),
    item_id uuid not null,
    action_taken text not null check (action_taken in ('updated', 'completed', 'deleted', 'added', 'deferred')),
    notes text,
    created_at timestamp with time zone default now() not null
);

-- Enable RLS
alter table public.weekly_reviews enable row level security;
alter table public.review_action_items enable row level security;

-- Weekly reviews policies
create policy "Enable read access for own weekly reviews"
    on weekly_reviews for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own weekly reviews"
    on weekly_reviews for insert
    with check (auth.uid() = user_id);

create policy "Enable update access for own weekly reviews"
    on weekly_reviews for update
    using (auth.uid() = user_id);

create policy "Enable delete access for own weekly reviews"
    on weekly_reviews for delete
    using (auth.uid() = user_id);

-- Review action items policies
create policy "Enable read access for own review action items"
    on review_action_items for select
    using (auth.uid() = user_id);

create policy "Enable insert access for own review action items"
    on review_action_items for insert
    with check (auth.uid() = user_id);

-- Add updated_at trigger
create trigger handle_updated_at
    before update on public.weekly_reviews
    for each row
    execute procedure public.handle_updated_at();

-- Add indexes
create index idx_weekly_reviews_user_id on public.weekly_reviews(user_id);
create index idx_weekly_reviews_review_date on public.weekly_reviews(review_date);
create index idx_review_action_items_review_id on public.review_action_items(review_id);

-- Helper functions
create or replace function get_latest_weekly_review(p_user_id uuid)
returns table (
    id uuid,
    review_date date,
    status text,
    completed_at timestamp with time zone
) as $$
begin
    return query
    select
        wr.id,
        wr.review_date,
        wr.status,
        wr.completed_at
    from public.weekly_reviews wr
    where wr.user_id = p_user_id
    order by wr.review_date desc
    limit 1;
end;
$$ language plpgsql security definer;

-- Function to get review streak
create or replace function get_review_streak(p_user_id uuid)
returns integer as $$
declare
    streak integer;
begin
    with consecutive_reviews as (
        select
            review_date,
            status,
            row_number() over (order by review_date desc) as rn,
            review_date - (row_number() over (order by review_date desc))::integer as grp
        from public.weekly_reviews
        where user_id = p_user_id
        and status = 'completed'
    )
    select count(*)
    into streak
    from consecutive_reviews
    where grp = (
        select grp
        from consecutive_reviews
        where rn = 1
    );

    return streak;
end;
$$ language plpgsql security definer;

-- Function to initialize weekly review
create or replace function initialize_weekly_review(p_user_id uuid)
returns uuid as $$
declare
    v_review_id uuid;
begin
    -- 今週のレビューが既に存在するかチェック
    if exists (
        select 1
        from public.weekly_reviews
        where user_id = p_user_id
        and review_date = date_trunc('week', now())::date
    ) then
        return null;
    end if;

    -- 新しいレビューを作成
    insert into public.weekly_reviews (
        user_id,
        review_date
    ) values (
        p_user_id,
        date_trunc('week', now())::date
    )
    returning id into v_review_id;

    return v_review_id;
end;
$$ language plpgsql security definer;