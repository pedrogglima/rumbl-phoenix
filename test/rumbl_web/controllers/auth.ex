def call(conn, _opts) do
  user_id = get_session(conn, :user_id)

  cond do
    conn.assigns[:current_user] ->
      conn

    user = user_id && Rumbl.Accounts.get_user(user_id) ->
      assign(conn, :current_user, user)

    true ->
      assign(conn, :current_user, nil)
  end
end
