defmodule AppWeb.PublicLive.FaqPage do
  use AppWeb, :surface_live_view

  data(current_user, :any, default: nil)

  def mount(_params, session, socket) do
    {:ok, maybe_assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~F"""
    <Nav id="navbar" active_page={:faq} current_user={@current_user} />

    <div class="bg-gray-50" x-data="{ openPanel: 0 }">
      <div class="px-4 py-12 mx-auto max-w-7xl sm:py-16 sm:px-6 lg:px-8">
        <div class="max-w-3xl mx-auto divide-y-2 divide-gray-200">
          <h2 class="text-3xl font-extrabold text-center text-gray-900 sm:text-4xl">
            Frequently asked questions
          </h2>
          <dl class="mt-6 space-y-6 divide-y divide-gray-200">
            <div class="pt-6">
              <dt class="text-lg">
                <button
                  @click="openPanel = (openPanel === 1 ? null : 1)"
                  class="flex items-start justify-between w-full text-left text-gray-400"
                >
                  <span class="font-medium text-gray-900">
                    What&#039;s the best thing about Switzerland?
                  </span>
                  <span class="flex items-center ml-6 h-7">
                    <svg
                      class="w-6 h-6 transform -rotate-180"
                      {%{
                        "x-bind:class" => "{ '-rotate-180': openPanel === 1, 'rotate-0': !(openPanel === 1) }"
                      }}
                      xmlns="http://www.w3.org/2000/svg"
                      fill="none"
                      viewBox="0 0 24 24"
                      stroke="currentColor"
                      aria-hidden="true"
                    >
                      <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M19 9l-7 7-7-7" />
                    </svg>
                  </span>
                </button>
              </dt>
              <dd class="pr-12 mt-2" x-show="openPanel === 1">
                <p class="text-base text-gray-500">
                  I don&#039;t know, but the flag is a big plus. Lorem ipsum dolor sit amet consectetur adipisicing elit. Quas cupiditate laboriosam fugiat.
                </p>
              </dd>
            </div>
          </dl>
        </div>
      </div>
    </div>
    """
  end
end
