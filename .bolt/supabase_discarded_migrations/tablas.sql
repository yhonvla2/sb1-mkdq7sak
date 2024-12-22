-- Políticas para usuarios
create policy "Los usuarios pueden ver sus propios datos"
  on public.usuarios for select
  using (auth.uid() = id);

create policy "Los usuarios pueden actualizar sus propios datos"
  on public.usuarios for update
  using (auth.uid() = id);

-- Políticas para canchas
create policy "Las canchas son visibles para todos"
  on public.canchas for select
  using (true);

-- Políticas para reservas
create policy "Los usuarios pueden ver sus propias reservas"
  on public.reservas for select
  using (auth.uid() = usuario_id);

create policy "Los usuarios pueden crear reservas"
  on public.reservas for insert
  with check (auth.uid() = usuario_id);

create policy "Los usuarios pueden cancelar sus reservas dentro del límite de tiempo"
  on public.reservas for update
  using (
    auth.uid() = usuario_id 
    and estado = 'confirmada'
    and (CURRENT_TIMESTAMP + interval '15 minutos') < (fecha::timestamp + hora_inicio::time)
  );

-- Políticas para administradores
create policy "Los administradores pueden ver todos los datos"
  on public.usuarios for select
  using (auth.uid() in (select id from public.administradores));

create policy "Los administradores pueden actualizar todos los datos de usuarios"
  on public.usuarios for update
  using (auth.uid() in (select id from public.administradores));

create policy "Los administradores pueden ver todas las reservas"
  on public.reservas for select
  using (auth.uid() in (select id from public.administradores));

create policy "Los administradores pueden actualizar todas las reservas"
  on public.reservas for update
  using (auth.uid() in (select id from public.administradores));

create policy "Los administradores pueden ver todos los horarios de las canchas"
  on public.canchas for select
  using (auth.uid() in (select id from public.administradores));
