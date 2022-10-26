defmodule MatchmakerWeb.AnswerSetLiveTest do
  use MatchmakerWeb.ConnCase

  import Phoenix.LiveViewTest
  import Matchmaker.AnswersFixtures

  @create_attrs %{description: "some description", title: "some title"}
  @update_attrs %{description: "some updated description", title: "some updated title"}
  @invalid_attrs %{description: nil, title: nil}

  defp create_answer_set(%{user: user}) do
    answer_set = answer_set_fixture(user)
    %{answer_set: answer_set}
  end

  describe "Index" do
    setup [:register_and_log_in_user, :create_answer_set]

    test "lists all answer_sets", %{conn: conn, answer_set: answer_set} do
      {:ok, _index_live, html} = live(conn, Routes.answer_set_index_path(conn, :index))

      assert html =~ "Listing Answer sets"
      assert html =~ answer_set.description
    end

    test "saves new answer_set", %{conn: conn} do
      {:ok, index_live, _html} = live(conn, Routes.answer_set_index_path(conn, :index))

      assert index_live |> element("a", "New Answer set") |> render_click() =~
               "New Answer set"

      assert_patch(index_live, Routes.answer_set_index_path(conn, :new))

      assert index_live
             |> form("#answer_set-form", answer_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#answer_set-form", answer_set: @create_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.answer_set_index_path(conn, :index))

      assert html =~ "Answer set created successfully"
      assert html =~ "some description"
    end

    test "updates answer_set in listing", %{conn: conn, answer_set: answer_set} do
      {:ok, index_live, _html} = live(conn, Routes.answer_set_index_path(conn, :index))

      assert index_live |> element("#answer_set-#{answer_set.id} a", "Edit") |> render_click() =~
               "Edit Answer set"

      assert_patch(index_live, Routes.answer_set_index_path(conn, :edit, answer_set))

      assert index_live
             |> form("#answer_set-form", answer_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        index_live
        |> form("#answer_set-form", answer_set: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.answer_set_index_path(conn, :index))

      assert html =~ "Answer set updated successfully"
      assert html =~ "some updated description"
    end

    test "deletes answer_set in listing", %{conn: conn, answer_set: answer_set} do
      {:ok, index_live, _html} = live(conn, Routes.answer_set_index_path(conn, :index))

      assert index_live |> element("#answer_set-#{answer_set.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#answer_set-#{answer_set.id}")
    end
  end

  describe "Show" do
    setup [:create_answer_set]

    test "displays answer_set", %{conn: conn, answer_set: answer_set} do
      {:ok, _show_live, html} = live(conn, Routes.answer_set_show_path(conn, :show, answer_set))

      assert html =~ "Show Answer set"
      assert html =~ answer_set.description
    end

    test "updates answer_set within modal", %{conn: conn, answer_set: answer_set} do
      {:ok, show_live, _html} = live(conn, Routes.answer_set_show_path(conn, :show, answer_set))

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Answer set"

      assert_patch(show_live, Routes.answer_set_show_path(conn, :edit, answer_set))

      assert show_live
             |> form("#answer_set-form", answer_set: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      {:ok, _, html} =
        show_live
        |> form("#answer_set-form", answer_set: @update_attrs)
        |> render_submit()
        |> follow_redirect(conn, Routes.answer_set_show_path(conn, :show, answer_set))

      assert html =~ "Answer set updated successfully"
      assert html =~ "some updated description"
    end
  end
end
