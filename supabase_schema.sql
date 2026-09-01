-- ==============================================================================
-- GLOW: منصة بناء العادات للأطفال والمتابعة الأسرية ولوحة تحكم المشرف (Admin)
-- Comprehensive Supabase SQL Schema (Tables, Indexes, RLS Policies)
-- هذا السكريبت آمن تماماً ويعمل حتى لو كانت الجداول موجودة مسبقاً (Idempotent)
-- ==============================================================================

-- 1. جدول أولياء الأمور (Parents)
CREATE TABLE IF NOT EXISTS public.parents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. جدول الأطفال والملفات الشخصية (Children)
CREATE TABLE IF NOT EXISTS public.children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT UNIQUE NOT NULL, -- مثال: PORT-8492
    parent_id TEXT REFERENCES public.parents(email) ON DELETE SET NULL,
    name TEXT NOT NULL,
    age INTEGER DEFAULT 7,
    selected_character TEXT DEFAULT 'PORT',
    avatar_shape TEXT DEFAULT 'shape_1',
    current_world INTEGER DEFAULT 1,
    stars INTEGER DEFAULT 0,
    points INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_children_code ON public.children(child_code);
CREATE INDEX IF NOT EXISTS idx_children_parent ON public.children(parent_id);

-- 3. جدول المهام المكتملة وتاريخ الإنجاز (Completed Missions)
CREATE TABLE IF NOT EXISTS public.completed_missions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT NOT NULL REFERENCES public.children(child_code) ON DELETE CASCADE,
    mission_id TEXT NOT NULL,
    habit_name TEXT NOT NULL,
    stars_earned INTEGER DEFAULT 3,
    points_earned INTEGER DEFAULT 150,
    completed_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_child_mission UNIQUE (child_code, mission_id)
);

-- 4. جدول الأوسمة والشارات المكتسبة (Earned Badges)
CREATE TABLE IF NOT EXISTS public.earned_badges (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT NOT NULL REFERENCES public.children(child_code) ON DELETE CASCADE,
    badge_name TEXT NOT NULL,
    unlocked_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_child_badge UNIQUE (child_code, badge_name)
);

-- 5. جدول متابعة العادات الأسرية (Habit Progress for Parents)
CREATE TABLE IF NOT EXISTS public.habit_progress (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT NOT NULL REFERENCES public.children(child_code) ON DELETE CASCADE,
    habit_id TEXT NOT NULL,
    status TEXT NOT NULL CHECK (status IN ('locked', 'inProgress', 'learned')),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    CONSTRAINT unique_child_habit UNIQUE (child_code, habit_id)
);

-- 6. جدول المنظمات التعليمية والمدارس (Organizations)
CREATE TABLE IF NOT EXISTS public.organizations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    org_name TEXT UNIQUE NOT NULL,
    admin_email TEXT NOT NULL,
    total_students INTEGER DEFAULT 0,
    active_classes INTEGER DEFAULT 0,
    compliance_rate INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. جدول العوالم والمراحل الديناميكية (Dynamic Worlds)
CREATE TABLE IF NOT EXISTS public.app_worlds (
    world_number INTEGER PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT NOT NULL,
    world_color_hex TEXT DEFAULT '#4E6E58',
    is_premium BOOLEAN DEFAULT FALSE,
    sort_order INTEGER DEFAULT 1,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 8. جدول المهام والقصص والأسئلة الديناميكية (Dynamic Missions, Stories & Quizzes)
CREATE TABLE IF NOT EXISTS public.app_missions (
    id TEXT PRIMARY KEY, -- مثال: w1_m1
    world_number INTEGER NOT NULL REFERENCES public.app_worlds(world_number) ON DELETE CASCADE,
    number INTEGER NOT NULL,
    title TEXT NOT NULL,
    habit_name TEXT NOT NULL,
    habit_description TEXT NOT NULL,
    reward_stars INTEGER DEFAULT 3,
    reward_points INTEGER DEFAULT 150,
    story_scenes JSONB DEFAULT '[]'::jsonb,
    quiz JSONB DEFAULT '{}'::jsonb,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

CREATE INDEX IF NOT EXISTS idx_missions_world ON public.app_missions(world_number);

-- 9. جدول الإعلانات والتوجيهات العامة (Announcements)
CREATE TABLE IF NOT EXISTS public.app_announcements (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    target_role TEXT DEFAULT 'all', -- all, child, parent, organization
    is_active BOOLEAN DEFAULT TRUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ==============================================================================
-- سياسات الأمان والوصول (Row Level Security - RLS)
-- ==============================================================================

ALTER TABLE public.parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.completed_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.earned_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_worlds ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.app_announcements ENABLE ROW LEVEL SECURITY;

DROP POLICY IF EXISTS "Public Read/Write Access for Children" ON public.children;
DROP POLICY IF EXISTS "Public Read/Write Access for Completed Missions" ON public.completed_missions;
DROP POLICY IF EXISTS "Public Read/Write Access for Earned Badges" ON public.earned_badges;
DROP POLICY IF EXISTS "Public Read/Write Access for Habit Progress" ON public.habit_progress;
DROP POLICY IF EXISTS "Public Read/Write Access for Parents" ON public.parents;
DROP POLICY IF EXISTS "Public Read/Write Access for Organizations" ON public.organizations;
DROP POLICY IF EXISTS "Public Read/Write Access for App Worlds" ON public.app_worlds;
DROP POLICY IF EXISTS "Public Read/Write Access for App Missions" ON public.app_missions;
DROP POLICY IF EXISTS "Public Read/Write Access for App Announcements" ON public.app_announcements;

CREATE POLICY "Public Read/Write Access for Children" ON public.children
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for Completed Missions" ON public.completed_missions
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for Earned Badges" ON public.earned_badges
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for Habit Progress" ON public.habit_progress
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for Parents" ON public.parents
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for Organizations" ON public.organizations
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for App Worlds" ON public.app_worlds
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for App Missions" ON public.app_missions
    FOR ALL USING (true) WITH CHECK (true);

CREATE POLICY "Public Read/Write Access for App Announcements" ON public.app_announcements
    FOR ALL USING (true) WITH CHECK (true);
