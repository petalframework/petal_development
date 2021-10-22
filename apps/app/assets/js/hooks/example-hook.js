// https://hexdocs.pm/phoenix_live_view/js-interop.html#client-hooks

// Note: when using phx-hook, a unique DOM ID must always be set.

const ExampleHook = {
  // the element has been added to the DOM and its server LiveView has finished mounting
  mounted() {
    let currentEl = this.el;

    // Handle an event from the server:
    // push_event(socket, "some_event", %{var1: 100})
    this.handleEvent("some_event", ({ var1 }) => {
      // do something with var1
    });
  },

  // the element is about to be updated in the DOM. Note: any call here must be synchronous as the operation cannot be deferred or cancelled.
  beforeUpdate() {},

  // the element has been updated in the DOM by the server
  updated() {},

  // the element has been removed from the page, either by a parent update, or by the parent being removed entirely
  destroyed() {},

  // the element's parent LiveView has disconnected from the server
  disconnected() {},

  // the element's parent LiveView has reconnected to the server
  reconnected() {},
};
