-- 1. Basic Task Selection
Select * from tasks limit 1000;


--  2. Project with Task Count
SELECT 
    p.id,
    p.name,
    p.tenant_ids,
    array_length(p.tenant_ids, 1) as tenant_count,
    COUNT(t.id) as task_count
FROM projects p
LEFT JOIN tasks t ON t.project_id = p.id
GROUP BY p.id, p.name, p.tenant_ids
ORDER BY task_count DESC
LIMIT 1000;


-- 3. project analytics query (100 records)
CREATE OR REPLACE FUNCTION get_projects_analytics(project_ids BIGINT[] DEFAULT NULL)
    RETURNS TABLE (
        project_id BIGINT,
        project_name TEXT,
        tenant_ids BIGINT[],
        total_tasks BIGINT,
        completed_tasks BIGINT,
        avg_estimated_hours NUMERIC,
        total_assignees BIGINT,
        avg_completion_time_hours NUMERIC
    )
    SECURITY INVOKER
    LANGUAGE plpgsql
AS $$
BEGIN
    PERFORM set_config('statement_timeout', '600000', true);
    RETURN QUERY
    WITH user_task_counts AS (
        SELECT 
            t.assigned_to,
            COUNT(t.id) AS tasks_count
        FROM tasks t
        GROUP BY t.assigned_to
    )
    SELECT 
        p.id AS project_id,
        p.name AS project_name,
        p.tenant_ids AS tenant_ids,
        COUNT(DISTINCT t.id) AS total_tasks,
        COUNT(DISTINCT t.id) FILTER (WHERE t.status = 'done') AS completed_tasks,
        ROUND(AVG(t.estimated_hours), 2) AS avg_estimated_hours,
        COUNT(DISTINCT t.assigned_to) AS total_assignees,
        ROUND(AVG(EXTRACT(EPOCH FROM (t.completed_at - t.created_at))/3600)::numeric, 2) AS avg_completion_time_hours
    FROM projects p
    LEFT JOIN tasks t ON t.project_id = p.id
    LEFT JOIN users u ON t.assigned_to = u.id
    WHERE 
        (project_ids IS NULL OR p.id = ANY(project_ids))
    GROUP BY p.id, p.name
    ORDER BY total_tasks DESC;
END;
$$;

SELECT get_projects_analytics(ARRAY[1000,1001,1002]);

