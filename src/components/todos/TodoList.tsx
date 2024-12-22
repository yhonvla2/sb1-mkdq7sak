import { useState, useEffect } from 'react';
import { supabase } from '../../lib/supabase';
import type { Todo } from '../../types/todo';

export function TodoList() {
  const [todos, setTodos] = useState<Todo[]>([]);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState<string | null>(null);

  useEffect(() => {
    async function fetchTodos() {
      try {
        setLoading(true);
        const { data, error } = await supabase
          .from('todos')
          .select('*')
          .order('created_at', { ascending: false });

        if (error) throw error;
        setTodos(data || []);
      } catch (err) {
        console.error('Error fetching todos:', err);
        setError(err instanceof Error ? err.message : 'Error fetching todos');
      } finally {
        setLoading(false);
      }
    }

    fetchTodos();
  }, []);

  if (loading) {
    return <div>Loading todos...</div>;
  }

  if (error) {
    return <div>Error: {error}</div>;
  }

  if (todos.length === 0) {
    return <div>No todos found</div>;
  }

  return (
    <ul className="space-y-2">
      {todos.map((todo) => (
        <li 
          key={todo.id}
          className="p-3 bg-white rounded-lg shadow"
        >
          {todo.name}
        </li>
      ))}
    </ul>
  );
}