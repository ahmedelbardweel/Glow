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

-- ==============================================================================
-- بيانات البذر الأولية (Initial Seed Data for Worlds & 10 Rich Missions)
-- ==============================================================================

-- إدراج العوالم السبعة
INSERT INTO public.app_worlds (world_number, name, description, world_color_hex, is_premium, sort_order)
VALUES
(1, 'غابة البدايات', 'عالم استكشاف العادات الأساسية: الثقة بالنفس، التعاون، النظافة، الصدق، والنوم المبكر.', '#4E6E58', false, 1),
(2, 'محيط المشاعر', 'عالم فهم المشاعر والذكاء العاطفي: إدارة الغضب، التعبير عن النفس، التعاطف، الصبر، والشجاعة الأدبية.', '#1D4ED8', false, 2),
(3, 'قلعة المسؤولية', 'عالم بناء الشخصية القيادية والمسؤولية: الاعتماد على النفس، الوفاء بالوعود، وبر الوالدين.', '#854D0E', false, 3),
(4, 'واحة الإبداع', 'عالم الابتكار والتفكير النقدي: الفضول العلمي، حب القراءة، وحل المشكلات بمرونة.', '#9333EA', false, 4),
(5, 'وادي العلاقات', 'عالم الصداقة والتواصل الإيجابي: التسامح، شكر الآخرين، وتقدير المشاعر.', '#059669', false, 5),
(6, 'أفق المستقبل', 'عالم الاستدامة والوعي البيئي والمالي: ثقافة الادخار، ترشيد الطاقة، ومساعدة المحتاجين.', '#D97706', false, 6),
(7, 'قمة الحكمة', 'عالم الحكمة والتأمل الإنساني: الرضا الداخلي، السلام النفسي، والامتنان للنعم.', '#B91C1C', false, 7)
ON CONFLICT (world_number) DO UPDATE SET
    name = EXCLUDED.name,
    description = EXCLUDED.description,
    world_color_hex = EXCLUDED.world_color_hex,
    is_premium = EXCLUDED.is_premium,
    sort_order = EXCLUDED.sort_order;

-- إدراج الـ 10 مهام لغابة البدايات مع المشاهد الصوتية والأسئلة
INSERT INTO public.app_missions (id, world_number, number, title, habit_name, habit_description, reward_stars, reward_points, story_scenes, quiz)
VALUES
(
    'w1_m1', 1, 1, 'شجاعة الصباح', 'الثقة بالنفس', 'الاعتزاز بالقدرات الشخصية والتعبير عن الرأي بوضوح وأدب.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "مرحباً بك يا بطلي! أنا PORT رفيقك وقائد رحلتك في غابة البدايات. اليوم سنكتشف قوة الثقة بالنفس والاعتزاز بقدراتنا.", "sceneDescription": "يقف PORT في مدخل الغابة الخضراء المشرقة ملوحاً بحماس لبدء الرحلة.", "backgroundTheme": "forest_day"},
        {"sceneIndex": 1, "speakerName": "FORT", "dialogue": "أنا FORT وأحب المغامرات! عندما ننظر للأمام بشجاعة وابتسامة، تصبح كل التحديات سهلة وممتعة.", "sceneDescription": "FORT يقفز بنشاط مشجعاً على المضي قدماً.", "backgroundTheme": "forest_bridge"},
        {"sceneIndex": 2, "speakerName": "PORT", "dialogue": "واجهنا جسراً خشبياً فوق النهر الهادئ. بالإرادة والهدوء نتجاوز كل خطوة بثقة ونجاح نحو القمة.", "sceneDescription": "جسر خشبي أنيق يمتد بين ضفتي النهر العذب.", "backgroundTheme": "forest_finish"}
    ]'::jsonb,
    '{
        "situation": "طلب المعلم في الصف مشاركة فكرة جديدة، وأنت لديك فكرة جميلة لكنك متردد:",
        "question": "ما هو التصرف الأكثر ثقة وإيجابية؟",
        "options": [
            {"keyId": "A", "text": "أرفع يدي بأدب وأشارك فكرتي بثقة وابتسامة.", "explanation": "رائع جداً! رفع اليد والمشاركة يعبر عن الثقة والحرص على التعلم."},
            {"keyId": "B", "text": "ألتزم الصمت التام ولا أتحدث أبداً.", "explanation": "الصمت يحرمك ويحرم أصدقاءك من الاستفادة من أفكارك الرائعة."},
            {"keyId": "C", "text": "أطلب من زميلي أن يتكلم بدلاً عني.", "explanation": "صوتك وفكرتك مميزان جداً ويستحقان أن تعبر عنهما بنفسك."},
            {"keyId": "D", "text": "أغلق دفاتري وأتجاهل الدرس.", "explanation": "تجاهل الدرس يضيع عليك فرصة التعلم والتألق في الصف."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "برافوو يا بطل! أحسنت الاختيار، الثقة بالنفس تصنع القادة دائماً.",
        "gentleFeedbackWrong": "محاولة جميلة! تذكر دائماً أن مشاركة أفكارك بجرأة وأدب هي سر النجاح والتفوق."
    }'::jsonb
),
(
    'w1_m2', 1, 2, 'يد واحدة في الحديقة', 'التعاون والمشاركة', 'مساعدة الأصدقاء والعائلة والعمل بروح الفريق الواحد.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "أهلاً بك مجدداً! اليوم يحتاج أصدقاؤنا إلى زراعة أزهار جديدة وترتيب حديقة الغابة الجميلة.", "sceneDescription": "حديقة واسعة تحتاج لترتيب وغرس الشتلات الملونة.", "backgroundTheme": "garden_start"},
        {"sceneIndex": 1, "speakerName": "MORT", "dialogue": "أنا MORT أحب العطف والمساعدة! عندما نضع أيدينا معاً يصبح العمل الشاق نزهة ممتعة ومليئة بالفرح.", "sceneDescription": "MORT يساعد في حمل الماء برفق ومحبة.", "backgroundTheme": "garden_work"},
        {"sceneIndex": 2, "speakerName": "QORT", "dialogue": "وأنا QORT الحكيم أقول لكم: التعاون يبني أجمل الحدائق وأقوى الصداقات التي تدوم طويلاً.", "sceneDescription": "QORT يشير إلى الأزهار المتفتحة بجمال.", "backgroundTheme": "garden_finish"}
    ]'::jsonb,
    '{
        "situation": "وجدت زميلك يحمل كتباً ثقيلة سقط بعضها على الأرض في ساحة المدرسة:",
        "question": "كيف تتصرف بمسؤولية وروح تعاون؟",
        "options": [
            {"keyId": "A", "text": "أبادر بابتسامة وأساعده في جمع الكتب وحمل جزء منها.", "explanation": "تصرف نبيل يعكس المروءة وحب الخير للآخرين."},
            {"keyId": "B", "text": "أمر من جانبه مسرعاً دون أن أنظر إليه.", "explanation": "تجاهل المحتاج يقلل من روح الأخوة والتعاون."},
            {"keyId": "C", "text": "أضحك على الموقف وأواصل المشي.", "explanation": "الضحك على تعثر الآخرين سلوك غير لائق ويجرح المشاعر."},
            {"keyId": "D", "text": "أنتظر حتى يطلب مني ذلك بصوت عالٍ.", "explanation": "المبادرة الذاتية للمساعدة تصنع الصداقات الحقيقية."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "ما أجمل تعاونك! أنت صديق يعتمد عليه في كل الأوقات.",
        "gentleFeedbackWrong": "محاولة طيبة! تذكر دائماً أن مساعدة غيرك تنشر المحبة وتجعل يومك أجمل."
    }'::jsonb
),
(
    'w1_m3', 1, 3, 'بريق الماء النقي', 'النظافة والترتيب', 'الحفاظ على نظافة الجسم، المكان، وترتيب الأدوات اليومية.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "وصلنا إلى واحة الينابيع النقية! النظافة تمنحنا الانتعاش والصحة وتحمينا من الأمراض.", "sceneDescription": "ينبوع ماء كريستالي صافٍ تتراقص حوله قطرات الندى.", "backgroundTheme": "spring_water"},
        {"sceneIndex": 1, "speakerName": "FORT", "dialogue": "غسل اليدين بالماء والصابون وترتيب غرفتنا يجعلنا نشعر بالطاقة والقوة في كل صباح!", "sceneDescription": "FORT يغسل يديه بسعادة تحت الينبوع.", "backgroundTheme": "spring_clean"},
        {"sceneIndex": 2, "speakerName": "MORT", "dialogue": "المكان النظيف يعكس جمال قلوبنا. لنحافظ دائماً على نظافة بيئتنا وأدواتنا لتبدو لامعة.", "sceneDescription": "MORT يبتسم مشيراً للمكان المرتب والنظيف.", "backgroundTheme": "spring_finish"}
    ]'::jsonb,
    '{
        "situation": "بعد الانتهاء من تناول وجبة الغداء اللذيذة مع الأسرة:",
        "question": "ما هي الخطوة الأفضل؟",
        "options": [
            {"keyId": "A", "text": "أساعد في رفع طبقي وأغسل يدي وفمي بالماء والصابون.", "explanation": "أحسنت! هذا قمة النظافة والبر بالوالدين وحسن السلوك."},
            {"keyId": "B", "text": "أترك الصحن على الطاولة وأركض للشاشة فوراً.", "explanation": "ترك الصحن يسبب الفوضى ويزيد العبء على أسرتك."},
            {"keyId": "C", "text": "أمسح يدي بملابسي دون غسيل.", "explanation": "مسح اليد بالملابس ينقل الجراثيم ويتلف الثياب."},
            {"keyId": "D", "text": "أنسى غسل فمي ويدي تماماً.", "explanation": "غسل اليدين يحميك من البكتيريا والجراثيم."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "بطل نظيف ومنظم! النظافة عنوان الرقي والأناقة دائماً.",
        "gentleFeedbackWrong": "محاولة جيدة! النظافة الشخصية والمساعدة المنزلية تجعل صحتنا وبيئتنا أفضل."
    }'::jsonb
),
(
    'w1_m4', 1, 4, 'كلمة الحق', 'الصدق والأمانة', 'قول الحقيقة دائماً بشجاعة والاعتراف بالخطأ والحرص على الأمانة.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "الصدق شجاعة حقيقية، وقول الحقيقة ينير دربنا ويبني ثقة الناس بنا دائماً.", "sceneDescription": "شجرة الصدق الوارفة تتلألأ بثمار المعرفة.", "backgroundTheme": "truth_tree"},
        {"sceneIndex": 1, "speakerName": "MORT", "dialogue": "حتى لو أخطأنا، فالاعتراف بالخطأ بصدق ولطف يجعلنا أبطالاً حقيقيين محبوبين لدى الجميع.", "sceneDescription": "MORT يشجع بحنان على قول الحق.", "backgroundTheme": "truth_speak"},
        {"sceneIndex": 2, "speakerName": "FORT", "dialogue": "الصدق كنز لا يفنى، ومن يقل الصدق يعش مرتاح البال ومرفوع الرأس بين أصدقائه.", "sceneDescription": "FORT يرفع شعلة الأمانة المضيئة.", "backgroundTheme": "truth_finish"}
    ]'::jsonb,
    '{
        "situation": "كسرت كأساً بالخطأ أثناء اللعب في الصالة:",
        "question": "كيف تتصرف بصدق وشجاعة؟",
        "options": [
            {"keyId": "A", "text": "أخبر والدي بالحقيقة وأعتذر بلطف وأساعد في تنظيف المكان بحذر.", "explanation": "ممتاز! الاعتراف بالخطأ شجاعة والصدق ينجي دائماً ويبني الثقة."},
            {"keyId": "B", "text": "أخفي الزجاج تحت السجادة أو وراء الأريكة.", "explanation": "إخفاء الزجاج قد يؤذي أحداً ويعد سلوكاً غير صادق."},
            {"keyId": "C", "text": "أقول أن القطة أو أخي الصغير هو من فعل ذلك.", "explanation": "إلقاء اللوم على الآخرين خطأ يضعف الثقة بك وبشخصيتك."},
            {"keyId": "D", "text": "أنكر معرفتي بالأمر وأغضب.", "explanation": "الإنكار لا يحل المشكلة بل يزيدها تعقيداً."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "أنت بطل حقيقي وصادق! الصدق يرفع من قدرك بين الجميع دائماً.",
        "gentleFeedbackWrong": "محاولة طيبة! تذكر أن قول الحقيقة بجرأة وأدب يمنحك احترام الجميع."
    }'::jsonb
),
(
    'w1_m5', 1, 5, 'أحلام النجوم', 'النوم المبكر والنشاط', 'تنظيم مواعيد النوم للاستيقاظ بنشاط وطاقة متجددة.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "عندما يحل المساء، يحتاج جسمنا وعقلنا للراحة لينمو ويكتسب القوة ليوم جديد مليء بالمغامرات!", "sceneDescription": "سماء هادئة مليئة بالنجوم المضيئة والقمر المبتسم.", "backgroundTheme": "starry_night"},
        {"sceneIndex": 1, "speakerName": "QORT", "dialogue": "النوم المبكر ينظم دقات القلب ويصفي الذهن لنستيقظ في الصباح بكامل الذكاء والتركيز.", "sceneDescription": "QORT ينظر للنجوم ويشرح أهمية راحة العقل.", "backgroundTheme": "starry_rest"},
        {"sceneIndex": 2, "speakerName": "PORT", "dialogue": "أغمض عينيك الليلة بابتسامة، فالغد ينتظرك بمغامرات أروع وأجمل يا صديقي البطل!", "sceneDescription": "PORT يلوح متمنياً نوماً هنيئاً وأحلاماً سعيدة.", "backgroundTheme": "starry_finish"}
    ]'::jsonb,
    '{
        "situation": "حان وقت النوم المحدد لك ولديك غداً مغامرة مدرسية شيقة:",
        "question": "ما هو القرار الأنسب؟",
        "options": [
            {"keyId": "A", "text": "أغلق الشاشات وأفرش أسناني وأذهب لسريري في الوقت المحدد.", "explanation": "رائع جداً! النوم الصحي يمنحك ذكاءً ونشاطاً استثنائياً."},
            {"keyId": "B", "text": "أسهر لساعات متأخرة ألعب بالأجهزة.", "explanation": "السهر يسبب التعب وضعف التركيز في اليوم التالي."},
            {"keyId": "C", "text": "أشرب مشروبات سكرية ومشروبات غازية قبل النوم.", "explanation": "السكريات قبل النوم تزعج نومك وتؤذي أسنانك."},
            {"keyId": "D", "text": "أرفض النوم حتى الصباح.", "explanation": "النوم غير المنتظم يضر بصحتك ونموك البدني."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "أحسنت يا بطل! النوم المبكر يصنع الأبطال الأذكياء.",
        "gentleFeedbackWrong": "محاولة جميلة! راحة الجسم ضرورية لتستيقظ بكامل طاقتك وإبداعك."
    }'::jsonb
),
(
    'w1_m6', 1, 6, 'احترام المواعيد', 'إدارة الوقت والالتزام', 'الحرص على أداء المهام في أوقاتها المحددة واحترام وقت الآخرين.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "الوقت كنز ثمين يا أصدقائي! والالتزام بالمواعيد يعكس احترامنا لأنفسنا وللآخرين.", "sceneDescription": "ساعة الغابة الكبيرة تدق بنغمات موسيقية منظمة.", "backgroundTheme": "clock_tower"},
        {"sceneIndex": 1, "speakerName": "FORT", "dialogue": "عندما ننجز واجباتنا أولاً في وقتها المحدد، نجد متسعاً كبيراً للعب والمرح دون قلق!", "sceneDescription": "FORT يرتب جدول أعماله اليومي بنشاط.", "backgroundTheme": "clock_schedule"},
        {"sceneIndex": 2, "speakerName": "QORT", "dialogue": "البطل الناجح هو من يقدر كل دقيقة ويجعل يومه مليئاً بالإنجاز والابتسامة.", "sceneDescription": "QORT يقف بثقة بجوار الساعة الذهبية.", "backgroundTheme": "clock_finish"}
    ]'::jsonb,
    '{
        "situation": "لديك واجب مدرسي وموعد لمشاهدة برنامجك المفضل:",
        "question": "كيف تنظم وقتك بذكاء؟",
        "options": [
            {"keyId": "A", "text": "أنهي واجبي بتركيز أولاً، ثم استمتع بمشاهدة برنامجي براحة بال.", "explanation": "أحسنت! إنجاز الأولويات أولاً هو أساس النجاح والتفوق."},
            {"keyId": "B", "text": "أشاهد التلفاز وأؤجل الواجب حتى الصباح الباكر.", "explanation": "التأجيل يسبب التوتر وعدم إتقان العمل."},
            {"keyId": "C", "text": "أترك واجبي تماماً وألعب طول اليوم.", "explanation": "إهمال الواجبات يقلل من تحصيلك العلمي."},
            {"keyId": "D", "text": "أكتب بسرعة وعشوائية أثناء المشاهدة.", "explanation": "تشتيت الانتباه يسبب الأخطاء وضعف الفهم."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "بطل منظم ورائع! إدارة الوقت سر من أسرار العباقرة.",
        "gentleFeedbackWrong": "محاولة طيبة! تذكر أن إنهاء المهام أولاً يمنحك راحة وسعادة حقيقية."
    }'::jsonb
),
(
    'w1_m7', 1, 7, 'طاقة الغذاء الصحي', 'التغذية السليمة وشرب الماء', 'تناول الخضروات والفواكه وشرب الماء النقي لبناء جسم قوي ومناعة عالية.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "شجرة الفواكه الملونة ترحب بنا! الأكل الصحي يمد عضلاتنا بالقوة وعقولنا بالذكاء.", "sceneDescription": "بستان مليء بالأشجار المثمرة بالتفاح والبرتقال والموز.", "backgroundTheme": "orchard_start"},
        {"sceneIndex": 1, "speakerName": "MORT", "dialogue": "الخضار الطازجة وشرب الماء النقي بانتظام يحمي جسمنا ويمنحنا نشاطاً لا ينتهي.", "sceneDescription": "MORT يوزع سلال الفواكه اللذيذة بحب.", "backgroundTheme": "orchard_fruits"},
        {"sceneIndex": 2, "speakerName": "FORT", "dialogue": "ابتعد عن السكريات الزائدة واختر دائماً طعام الأبطال لتكون الأقوى والأسرع في كل تحدٍ!", "sceneDescription": "FORT يركض بحيوية وطاقة عالية بين الأشجار.", "backgroundTheme": "orchard_finish"}
    ]'::jsonb,
    '{
        "situation": "شعرت بالعطش والجوع الخفيف بين الوجبات:",
        "question": "ما هو الخيار الأكثر صحة لجسمك؟",
        "options": [
            {"keyId": "A", "text": "أشرب كوباً من الماء النقي وأتناول تفاحة أو موزة طازجة.", "explanation": "اختيار عبقري! الفواكه والماء تمنحك فيتامينات وطاقة طبيعية نقية."},
            {"keyId": "B", "text": "أشرب مشروباً غازياً مليئاً بالسكريات.", "explanation": "المشروبات الغازية تضر الأسنان والمعدة."},
            {"keyId": "C", "text": "آكل حلوى مصنعة ملونة ومقرمشات ضارة.", "explanation": "الحلويات الزائدة تسبب الخمول وتضعف المناعة."},
            {"keyId": "D", "text": "أهمل شرب الماء تماماً.", "explanation": "الماء ضروري جداً لترطيب الجسم وصحة العقل."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "يا لك من بطل صحي وذكي! غذاؤك الصحي يبني مستقبلك القوي.",
        "gentleFeedbackWrong": "محاولة طيبة! تذكر دائماً أن صحتك أمانة وغذاءك النظيف هو طاقتك الحقيقية."
    }'::jsonb
),
(
    'w1_m8', 1, 8, 'كنز الكلمات الطيبة', 'اللباقة والحديث الإيجابي', 'استخدام الكلمات المهذبة والثناء على الآخرين والابتعاد عن الألفاظ السيئة.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "الكلمة الطيبة كشجرة وارفة، تنشر الفرح في كل مكان وتصنع أصدقاء أوفياء في كل خطوة.", "sceneDescription": "وادي الصدى المضيء يردد الكلمات الجميلة بنغمات رائعة.", "backgroundTheme": "kind_words_start"},
        {"sceneIndex": 1, "speakerName": "QORT", "dialogue": "استخدام عبارات مثل شكراً، ومن فضلك، ولو سمحت تفتح لك القلوب وتجعلك مميزاً ومحبوباً.", "sceneDescription": "QORT يبتسم وينصح بلباقة وحكمة.", "backgroundTheme": "kind_words_echo"},
        {"sceneIndex": 2, "speakerName": "MORT", "dialogue": "عندما نتحدث بلطف وهدوء، نصبح قدوة حسنة ونسعد عائلتنا ومعلمينا في كل لحظة.", "sceneDescription": "MORT يعانق أصدقاءه بمودة ولطف.", "backgroundTheme": "kind_words_finish"}
    ]'::jsonb,
    '{
        "situation": "أعطاك صديقك أو والدك شيئاً جميلاً طلبته منه:",
        "question": "ما هي الكلمة الأجمل لتقولها؟",
        "options": [
            {"keyId": "A", "text": "أبتسم وأقول: شكراً جزيلاً لك، جزاك الله خيراً.", "explanation": "سلوك رفيع يعبر عن التقدير والامتنان ومكارم الأخلاق."},
            {"keyId": "B", "text": "آخذ الشيء دون أن أتكلم أو أنظر إليه.", "explanation": "عدم الشكر يقلل من المودة بين الناس."},
            {"keyId": "C", "text": "أقول: هذا أقل مما أردت، وأتذمر.", "explanation": "التذمر يجرح مشاعر من يحاول إسعادك."},
            {"keyId": "D", "text": "أرمي الشيء على الأرض بإهمال.", "explanation": "إهمال الهدايا سلوك غير لائق."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "ما أجمل لسانك وأخلاقك! صاحب الكلمات الطيبة محبوب من الجميع دائماً.",
        "gentleFeedbackWrong": "محاولة جميلة! تذكر أن الشكر والامتنان ينشران المحبة في كل مكان."
    }'::jsonb
),
(
    'w1_m9', 1, 9, 'حماية الطبيعة الخضراء', 'المحافظة على البيئة والأشجار', 'وضع المهملات في مكانها المخصص، وترشيد استهلاك الورق والمياه، والعناية بالنباتات.', 3, 150,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "انظروا إلى جمال هذه الغابة والورود المتفتحة! مسؤوليتنا جميعاً الحفاظ على بيئتنا نقية وجميلة.", "sceneDescription": "مرج أخضر واسع تتفتح فيه الزهور البرية وتغرد العصافير.", "backgroundTheme": "nature_start"},
        {"sceneIndex": 1, "speakerName": "FORT", "dialogue": "رمي المهملات في سلتها المخصصة وعدم قطف الأزهار يحفظ بيئتنا للأجيال القادمة لتستمتع بها.", "sceneDescription": "FORT يضع عبوة في صندوق إعادة التدوير بحماس.", "backgroundTheme": "nature_recycle"},
        {"sceneIndex": 2, "speakerName": "MORT", "dialogue": "النباتات كائنات حية تمنحنا الأكسجين والجمال، لنعتنِ بها ونسقِها بالماء والاهتمام المستمر.", "sceneDescription": "MORT يسقي شتلة صغيرة بحنان.", "backgroundTheme": "nature_finish"}
    ]'::jsonb,
    '{
        "situation": "كنت في نزهة بالحديقة العامة وانتهيت من تناول وجبة خفيفة:",
        "question": "أين تضع غلاف الطعام والعلبة الفارغة؟",
        "options": [
            {"keyId": "A", "text": "أجمع كل المخلفات وأضعها في سلة المهملات المخصصة.", "explanation": "بطل بيئي حقيقي! نظافة الأماكن العامة مسؤولية وواجب يعكس وعيك."},
            {"keyId": "B", "text": "أتركها على العشب الأخضر وأغادر.", "explanation": "ترك المهملات يشوه الطبيعة ويؤذي الحيوانات والزوار."},
            {"keyId": "C", "text": "أرميها في بركة الماء أو تحت الشجرة.", "explanation": "تلويث المياه والأشجار يضر بالبيئة والكائنات الحية."},
            {"keyId": "D", "text": "أدفنها في التراب عشوائياً.", "explanation": "البلاستيك لا يتحلل ويؤذي التربة الزراعية."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "بطل البيئة الرائع! بفضلك تظل مدينتنا وغاباتنا جنة خضراء جميلة.",
        "gentleFeedbackWrong": "محاولة طيبة! تذكر دائماً أن النظافة العامة مظهر حضاري وشارة للأبطال."
    }'::jsonb
),
(
    'w1_m10', 1, 10, 'تحدي القائد الشجاع', 'المثابرة والتفوق', 'مواصلة المحاولة وعدم الاستسلام والوصول إلى الأهداف بثبات واعتزاز.', 3, 200,
    '[
        {"sceneIndex": 0, "speakerName": "PORT", "dialogue": "مرحى! لقد وصلنا إلى قمة جبل البدايات بعد رحلة رائعة مليئة بالتعلم والعادات العظيمة.", "sceneDescription": "قمة جبل شاهقة تطل على غابة البدايات كاملة تحت أشعة الشمس الذهبية.", "backgroundTheme": "summit_start"},
        {"sceneIndex": 1, "speakerName": "FORT", "dialogue": "الصبر والمثابرة هما سر الوصول إلى القمة! لم نستسلم أمام أي عائق حتى حققنا هدفنا بجدارة.", "sceneDescription": "FORT يرفع راية النصر والتفوق عالياً.", "backgroundTheme": "summit_flag"},
        {"sceneIndex": 2, "speakerName": "MORT", "dialogue": "والآن أصبحت تمتلك عادات القادة العظماء: الصدق، النظافة، التعاون، واحترام الوقت والمواعيد.", "sceneDescription": "MORT يصفق بفخر واعتزاز بالبطل الصغير.", "backgroundTheme": "summit_cheer"},
        {"sceneIndex": 3, "speakerName": "QORT", "dialogue": "فخورون بك جميعاً يا بطل GLOW! استعد الآن للحصول على وسام غابة البدايات الذهبي والانطلاق للعالم التالي!", "sceneDescription": "QORT يمسك بالوسام الذهبي اللامع وسط احتفال أبطال GLOW.", "backgroundTheme": "summit_trophy"}
    ]'::jsonb,
    '{
        "situation": "واجهتك مسألة رياضية أو لعبة تركيب صعبة ولم تنجح من أول محاولة:",
        "question": "ما هو تصرف القائد المثابر؟",
        "options": [
            {"keyId": "A", "text": "أهدأ، وأفكر بطريقة جديدة، وأحاول مرة بعد أخرى حتى أنجح بتفوق.", "explanation": "هذه عقلية الأبطال! الإصرار والمحاولة هما طريق كل نجاح واكتشاف عظيم."},
            {"keyId": "B", "text": "أغضب وأرمي اللعبة أو الورقة وأستسلم.", "explanation": "الاستسلام يحرمك من متعة الفوز والتعلم."},
            {"keyId": "C", "text": "أقول: أنا لا أستطيع فعل أي شيء مفيد.", "explanation": "أنت قادر ومميز، وكل محاولة تزيدك ذكاءً وخبرة."},
            {"keyId": "D", "text": "أطلب من شخص آخر حلها لي بالكامل دون أن أحاول.", "explanation": "الاعتماد الكلي على الآخرين يمنعك من تطوير مهاراتك الذاتية."}
        ],
        "correctKeyId": "A",
        "encouragementCorrect": "يا لك من قائد عبقري ومثابر! قمة المجد تليق بك دائماً يا بطل.",
        "gentleFeedbackWrong": "محاولة رائعة! تذكر أن كل فشل هو خطوة نحو النجاح إذا واصلت المحاولة بإصرار."
    }'::jsonb
)
ON CONFLICT (id) DO UPDATE SET
    world_number = EXCLUDED.world_number,
    number = EXCLUDED.number,
    title = EXCLUDED.title,
    habit_name = EXCLUDED.habit_name,
    habit_description = EXCLUDED.habit_description,
    reward_stars = EXCLUDED.reward_stars,
    reward_points = EXCLUDED.reward_points,
    story_scenes = EXCLUDED.story_scenes,
    quiz = EXCLUDED.quiz;

