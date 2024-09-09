defmodule WebsterScraper do
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
    {:ok, document} = Floki.parse_document(html)

    
  end
end
