-- シードデータ作成用のSQLファイル
-- テストユーザーの作成
INSERT INTO auth.users (
    instance_id,
    id,
    aud,
    role,
    email,
    encrypted_password,
    email_confirmed_at,
    created_at,
    updated_at,
    confirmation_token,
    email_change,
    email_change_token_new,
    recovery_token
) VALUES (
    '00000000-0000-0000-0000-000000000000',
    '11111111-1111-1111-1111-111111111111',
    'authenticated',
    'authenticated',
    'test@example.com',
    crypt('password123', gen_salt('bf')),
    NOW(),
    NOW(),
    NOW(),
    '',
    '',
    '',
    ''
);

DO $$
DECLARE
    test_user_id uuid := '11111111-1111-1111-1111-111111111111';
BEGIN

-- areas テーブルのシードデータ
INSERT INTO public.areas (id, title, user_id, is_archived, created_at, updated_at)
VALUES
  ('123e4567-e89b-12d3-a456-426614174000', '仕事', test_user_id, false, NOW(), NOW()),
  ('123e4567-e89b-12d3-a456-426614174001', '個人開発', test_user_id, false, NOW(), NOW()),
  ('123e4567-e89b-12d3-a456-426614174002', '健康', test_user_id, false, NOW(), NOW());

-- projects テーブルのシードデータ
INSERT INTO public.projects (id, title, area_id, user_id, status, desired_outcome, created_at, updated_at)
VALUES
  ('223e4567-e89b-12d3-a456-426614174000', 'プロジェクトA', '123e4567-e89b-12d3-a456-426614174000', test_user_id, 'active', 'プロジェクトAの目標達成', NOW(), NOW()),
  ('223e4567-e89b-12d3-a456-426614174001', 'プロジェクトB', '123e4567-e89b-12d3-a456-426614174001', test_user_id, 'active', 'アプリケーションのリリース', NOW(), NOW()),
  ('223e4567-e89b-12d3-a456-426614174002', '運動習慣の確立', '123e4567-e89b-12d3-a456-426614174002', test_user_id, 'active', '週3回の運動習慣を確立する', NOW(), NOW());

-- actions テーブルのシードデータ
INSERT INTO public.actions (id, title, project_id, user_id, status, context, energy_level, time_slot, created_at, updated_at)
VALUES
  ('323e4567-e89b-12d3-a456-426614174000', 'タスク1', '223e4567-e89b-12d3-a456-426614174000', test_user_id, 'next', 'office', 3, 'morning', NOW(), NOW()),
  ('323e4567-e89b-12d3-a456-426614174001', 'タスク2', '223e4567-e89b-12d3-a456-426614174000', test_user_id, 'next', 'computer', 2, 'afternoon', NOW(), NOW()),
  ('323e4567-e89b-12d3-a456-426614174002', 'ジムの入会手続き', '223e4567-e89b-12d3-a456-426614174002', test_user_id, 'next', 'errands', 3, 'evening', NOW(), NOW());

-- inbox_items テーブルのシードデータ
INSERT INTO public.inbox_items (id, title, content, user_id, processed, source, created_at, updated_at)
VALUES
  ('423e4567-e89b-12d3-a456-426614174000', '新しいアイデア', 'アプリケーションの改善案について', test_user_id, false, 'thought', NOW(), NOW()),
  ('423e4567-e89b-12d3-a456-426614174001', 'ミーティングメモ', '先週のミーティングの内容をまとめる', test_user_id, false, 'meeting', NOW(), NOW());

-- weekly_reviews テーブルのシードデータ
INSERT INTO public.weekly_reviews (id, user_id, review_date, status, started_at, created_at, updated_at)
VALUES
  ('523e4567-e89b-12d3-a456-426614174000', test_user_id, CURRENT_DATE, 'in_progress', NOW(), NOW(), NOW());

END $$;