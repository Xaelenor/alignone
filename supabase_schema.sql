-- Supabase Schema for AlignOne

-- 1. Profiles Table
CREATE TABLE profiles (
  id UUID REFERENCES auth.users NOT NULL PRIMARY KEY,
  updated_at TIMESTAMP WITH TIME ZONE,
  username TEXT UNIQUE,
  full_name TEXT,
  avatar_url TEXT
);

ALTER TABLE profiles ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Public profiles are viewable by everyone." ON profiles
  FOR SELECT USING (true);

CREATE POLICY "Users can insert their own profile." ON profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile." ON profiles
  FOR UPDATE USING (auth.uid() = id);

-- 2. Life Areas Table
CREATE TABLE life_areas (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  name TEXT NOT NULL,
  description TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

ALTER TABLE life_areas ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own life areas." ON life_areas
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own life areas." ON life_areas
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own life areas." ON life_areas
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own life areas." ON life_areas
  FOR DELETE USING (auth.uid() = user_id);

-- 3. Daily Actions Table
CREATE TABLE daily_actions (
  id UUID DEFAULT uuid_generate_v4() PRIMARY KEY,
  user_id UUID REFERENCES auth.users NOT NULL,
  life_area_id UUID REFERENCES life_areas ON DELETE CASCADE,
  action_text TEXT NOT NULL,
  notes TEXT,
  completed BOOLEAN DEFAULT false NOT NULL,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
  date_local DATE NOT NULL, -- To query by local day easily
  completed_at TIMESTAMP WITH TIME ZONE
);

ALTER TABLE daily_actions ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Users can view their own daily actions." ON daily_actions
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert their own daily actions." ON daily_actions
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update their own daily actions." ON daily_actions
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete their own daily actions." ON daily_actions
  FOR DELETE USING (auth.uid() = user_id);

-- Trigger to create profile after signup
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS trigger AS $$
BEGIN
  INSERT INTO public.profiles (id, full_name)
  VALUES (new.id, new.raw_user_meta_data->>'full_name');
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();
