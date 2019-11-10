defmodule KommissarWeb.Guardian do
  use Guardian, otp_app: :kommissar

  alias Kommissar.Accounts.User

  def subject_for_token(%User{} = resource, _claims) do
    sub = resource.id
    {:ok, sub}
  end
  def subject_for_token(_, _) do
    {:error, :unauthorized}
  end

  def resource_from_claims(%{} = claims) do
    id = claims["sub"]
    resource = Kommissar.Accounts.get_user!(id)
    {:ok,  resource}
  end
  def resource_from_claims(_claims) do
    {:error, :unauthorized}
  end
end
