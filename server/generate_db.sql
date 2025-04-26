-- Create Tables
CREATE TABLE public.doc_updates (
    task_id uuid NOT NULL, 
    instance_id uuid, 
    server_updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    server_created_at timestamp with time zone NOT NULL DEFAULT now(), 
    id uuid NOT NULL, 
    user_id uuid NOT NULL, 
    data_b64 text NOT NULL, 
    deleted_at timestamp with time zone, 
    updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

CREATE TABLE public.project (
    name text NOT NULL, 
    id uuid NOT NULL, 
    created_at timestamp with time zone NOT NULL DEFAULT now(), 
    updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    deleted_at timestamp with time zone, 
    user_id uuid NOT NULL, 
    server_created_at timestamp with time zone NOT NULL DEFAULT now(), 
    server_updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    instance_id uuid
);

CREATE TABLE public.task (
    id uuid NOT NULL, 
    instance_id uuid, 
    server_updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    server_created_at timestamp with time zone NOT NULL DEFAULT now(), 
    user_id uuid NOT NULL, 
    project_id uuid NOT NULL, 
    name text NOT NULL, 
    deleted_at timestamp with time zone, 
    updated_at timestamp with time zone NOT NULL DEFAULT now(), 
    created_at timestamp with time zone NOT NULL DEFAULT now()
);

-- Add Primary Keys
ALTER TABLE public.doc_updates ADD CONSTRAINT doc_updates_pkey PRIMARY KEY (id);
ALTER TABLE public.project ADD CONSTRAINT project_pkey PRIMARY KEY (id);
ALTER TABLE public.task ADD CONSTRAINT task_pkey PRIMARY KEY (id);

-- Enable Row Level Security and Create Policies
ALTER TABLE public.task ENABLE ROW LEVEL SECURITY;
CREATE POLICY "task_rls" ON public.task 
    FOR ALL 
    TO authenticated 
    USING ((auth.uid() = user_id)) 
    WITH CHECK ((auth.uid() = user_id));

ALTER TABLE public.project ENABLE ROW LEVEL SECURITY;
CREATE POLICY "project_rls" ON public.project 
    FOR ALL 
    TO authenticated 
    USING ((auth.uid() = user_id)) 
    WITH CHECK ((auth.uid() = user_id));

ALTER TABLE public.doc_updates ENABLE ROW LEVEL SECURITY;
CREATE POLICY "doc_updates_rls" ON public.doc_updates 
    FOR ALL 
    TO authenticated 
    USING ((auth.uid() = user_id)) 
    WITH CHECK ((auth.uid() = user_id));