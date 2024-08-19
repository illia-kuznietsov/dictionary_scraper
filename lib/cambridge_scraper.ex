defmodule CambridgeScraper do
  @moduledoc """
  Documentation for `CambridgeScraper`.
  """

  def scrape(url) do
    case HTTPoison.get(url) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        parse_html(body)

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch page. Status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  defp parse_html(html) do
    # Parse the HTML body
    {:ok, document} = Floki.parse_document(html)

    titles = Floki.find(document, "div.di-title")
    definitions = Floki.find(document, "div.def.ddef_d.db")

    Enum.zip(titles, definitions)
    |> Enum.map(fn {title, definition} ->
      %{title: Floki.text(title), definition: Floki.text(definition)}
    end)
  end
end
