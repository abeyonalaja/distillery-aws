use Mix.Config

config :distillery_example, ExampleWeb.Endpoint,
  server: true,
  cache_static_manifest: "priv/static/cache_manifest.json",
  version: Application.spec(:distillery_example, :vsn)

#config :distillery_example, Example.Repo, adapter: Ecto.Adapters.Postgres

config :logger,
  level: :info,
  handle_sasl_reports: true,
  handle_otp_reports: true
# Pull database password from SSM
db_secret_name = "/#{app}/#{env}/database/password"
db_password =
  case System.cmd(aws, ["ssm", "get-parameter", "--region=#{region}", "--name=#{db_secret_name}", "--with-decryption"]) do
    {json, 0} ->
      %{"Parameter" => %{"Value" => password}} = Jason.decode!(json)
      password
    {output, status} ->
      raise "Unable to get database password, command exited with status #{status}:\n#{output}"
  end

config :distillery_example, Example.Repo,
       username: System.get_env("DATABASE_USER"),
       password: db_password,
       database: System.get_env("DATABASE_NAME"),
       hostname: System.get_env("DATABASE_HOST"),
       show_sensitive_data_on_connection_error: true,
       pool_size: 15