defmodule MatchmakerWeb.Components.Menu do
  defmodule Item do
    use Surface.Component, slot: "items"

    slot items
    slot default

    def render(assigns) do
      ~F"""
      {#if slot_assigned?(:items)}
        <li role="list" dir="rtl">
          <a href="#" aria-haspopup="listbox"><#slot name="default" /></a>
          <ul role="listbox">
            {#for {_, index} <- Enum.with_index(@items)}
              <li>
                <Context put={is_sub_item: true}>
                  <#slot name="items" index={index} />
                </Context>
              </li>
            {/for}
          </ul>
        </li>
      {#else}
        <Context get={is_sub_item: is_sub_item}>
          {#if is_sub_item != true }
            <li>
              <#slot name="default" />
            </li>
          {#else}
            <#slot name="default" />
          {/if}
        </Context>
      {/if}
      """
    end

  end

  defmodule Brand do
    use Surface.Component, slot: "brand"
  end

  use Surface.Component

  slot(brand)
  slot(items, required: true)

  def render(assigns) do
    ~F"""
      <nav>
        <ul><li><a href="#" class="secondary">{raw hamburger()}</a></li></ul>
        <ul>
          {#for {_item, index} <- Enum.with_index(@items)}
            <#slot name="items" index={index} />
          {/for}
        </ul>
        <ul>
          {#if slot_assigned?(:brand)}
            {#for {_brand, index} <- Enum.with_index(@brand)}
              <li><#slot name="brand" index={index} /></li>
            {/for}
          {/if}
        </ul>
      </nav>
    """
  end

  defp hamburger,
    do: """
    <svg aria-hidden="true" focusable="false" role="img" xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24" height="16px" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><line x1="3" y1="12" x2="21" y2="12"></line><line x1="3" y1="6" x2="21" y2="6"></line><line x1="3" y1="18" x2="21" y2="18"></line></svg>
    """
end
