defmodule Terrarium.Device do
  # This enforces structure. A device MUST have an id, attributes, and connection status.
  # "derive Jason.Encoder" allows this struct to be turned into JSON automatically for the frontend.
  @derive {Jason.Encoder, only: [:id, :attrs, :connected, :last_seen]}
  defstruct [:id, :attrs, :connected, :last_seen]

  # Helper to create a new struct with defaults
  def new(id, attrs \\ %{}) do
    %__MODULE__{
      id: id,
      attrs: attrs,
      connected: true,
      last_seen: DateTime.utc_now()
    }
  end
end
