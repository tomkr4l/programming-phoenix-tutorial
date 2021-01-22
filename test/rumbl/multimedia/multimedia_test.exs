defmodule Rumbl.MultimediaTest do
  use Rumbl.DataCase

  alias Rumbl.Multimedia
  alias Rumbl.Multimedia.Category

  describe "categories" do
    test "list_alphabetical_categories/0" do
      for name <- ~w(Drama Action Comedy), do: Multimedia.create_category(name)

      alpha_names =
        for %Category{name: name} <- Multimedia.list_alphabetical_categories() do
          name
        end
      assert alpha_names == ~w(Action Comedy Drama)
    end
  end

  describe "videos" do
    alias Rumbl.Multimedia.Video

    @valid_attrs %{description: "desc", title: "title", url: "http://local"}
    @invalid_attrs %{description: nil, title: nil, url: nil}

    test "list_videos/0 returns all videos" do
      owner = user_fixture()
      %Video{id: id1} = video_fixture(owner)
      assert [%Video{id: ^id1}] = Multimedia.list_videos()
      %Video{id: id2} = video_fixture(owner)
      assert [%Video{id: ^id1}, %Video{id: ^id2}] = Multimedia.list_videos()
    end
  end
end
