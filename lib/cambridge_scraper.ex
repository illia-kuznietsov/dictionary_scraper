defmodule CambridgeScraper do
  @moduledoc """
  Documentation for `CambridgeScraper`.
  """
  @url "https://dictionary.cambridge.org/dictionary/english/"

  def search(word) when is_binary(word), do: scrape(@url <> word)

  defp scrape(url) do
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

    definitions =
      Floki.find(document, "div.def.ddef_d.db")
      |> Floki.traverse_and_update(fn
        {"div", params, children} ->
          {"div", params,
           [
             children
             |> Enum.map_join(" ",
               &case &1 do
                 {"a", _, text} -> Enum.join(text, " ") |> String.trim()
                 text when is_binary(text) -> String.trim(text)
               end
             )
           ]}

      #   other ->
      #     other
      # end)

    Enum.zip(titles, definitions)
    |> Enum.map(fn {title, definition} ->
      %{
        title: title |> Floki.text(),
        definition: definition |> Floki.text()
      }
    end)
  end
end
