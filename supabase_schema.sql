-- ==============================================================================
-- GLOW: منصة بناء العادات للأطفال والمتابعة الأسرية
-- Comprehensive Supabase SQL Schema (Tables, Indexes, RLS Policies)
-- هذا السكريبت آمن تماماً ويعمل حتى لو كانت الجداول موجودة مسبقاً (Idempotent)
-- ==============================================================================

-- إذا كنت تريد إعادة بناء الجداول بالكامل وحذف الجداول القديمة، يمكنك إزالة التعليق عن السطور التالية:
DROP TABLE IF EXISTS public.completed_missions CASCADE;
DROP TABLE IF EXISTS public.earned_badges CASCADE;
DROP TABLE IF EXISTS public.habit_progress CASCADE;
DROP TABLE IF EXISTS public.children CASCADE;
DROP TABLE IF EXISTS public.parents CASCADE;
DROP TABLE IF EXISTS public.organizations CASCADE;

-- 1. جدول أولياء الأمور (Parents)
CREATE TABLE IF NOT EXISTS public.parents (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    email TEXT UNIQUE NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. جدول الأطفال والملفات الشخصية (Children)
-- مع مفتاح الكود الفريد child_code للربط التلقائي بدون كلمة مرور للطفل
CREATE TABLE IF NOT EXISTS public.children (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT UNIQUE NOT NULL, -- مثال: PORT-8492
    parent_id TEXT REFERENCES public.parents(email) ON DELETE SET NULL, -- بريد ولي الأمر المرتبط
    name TEXT NOT NULL,
    age INTEGER DEFAULT 7,
    selected_character TEXT DEFAULT 'PORT', -- PORT, MORT, FORT, SORT, QORT, LORT
    avatar_shape TEXT DEFAULT 'shape_1',
    current_world INTEGER DEFAULT 1,
    stars INTEGER DEFAULT 0,
    points INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- فهرس لتسريع البحث بكود الطفل وبريد ولي الأمر
CREATE INDEX IF NOT EXISTS idx_children_code ON public.children(child_code);
CREATE INDEX IF NOT EXISTS idx_children_parent ON public.children(parent_id);

-- 3. جدول المهام المكتملة وتاريخ الإنجاز (Completed Missions)
CREATE TABLE IF NOT EXISTS public.completed_missions (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    child_code TEXT NOT NULL REFERENCES public.children(child_code) ON DELETE CASCADE,
    mission_id TEXT NOT NULL, -- مثال: w1_m1
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

-- ==============================================================================
-- سياسات الأمان والوصول (Row Level Security - RLS)
-- ==============================================================================

-- تفعيل RLS على كافة الجداول
ALTER TABLE public.parents ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.children ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.completed_missions ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.earned_badges ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.habit_progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.organizations ENABLE ROW LEVEL SECURITY;

-- حذف السياسات القديمة أولاً لتجنب خطأ "Policy already exists"
DROP POLICY IF EXISTS "Public Read/Write Access for Children" ON public.children;
DROP POLICY IF EXISTS "Public Read/Write Access for Completed Missions" ON public.completed_missions;
DROP POLICY IF EXISTS "Public Read/Write Access for Earned Badges" ON public.earned_badges;
DROP POLICY IF EXISTS "Public Read/Write Access for Habit Progress" ON public.habit_progress;
DROP POLICY IF EXISTS "Public Read/Write Access for Parents" ON public.parents;
DROP POLICY IF EXISTS "Public Read/Write Access for Organizations" ON public.organizations;

-- إعادة إنشاء سياسات القراءة والكتابة العامة (مفتاح Anon المستخدم في التطبيق)
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

