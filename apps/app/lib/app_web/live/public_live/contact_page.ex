defmodule AppWeb.PublicLive.ContactPage do
  use AppWeb, :surface_live_view
  alias App.Accounts.UserNotifier

  data(contact_form_submitted, :boolean, default: false)
  data(current_user, :any, default: nil)

  def mount(_params, session, socket) do
    {:ok, maybe_assign_current_user(socket, session)}
  end

  def render(assigns) do
    ~F"""
    <Nav id="navbar" active_page={:contact} current_user={@current_user} />

    <div class="bg-gray-50">
      <div class="relative z-10 py-24 overflow-hidden lg:py-32">
        <div class="pl-4 pr-8 mx-auto max-w-7xl sm:px-6 lg:px-8">
          <h1 class="text-4xl font-extrabold tracking-tight text-gray-900 sm:text-5xl lg:text-6xl">Get in touch {@current_user.name}</h1>
          <p class="max-w-3xl mt-6 text-xl text-gray-500">We'll get back to you asap!</p>
        </div>
      </div>
    </div>

    <section class="relative pb-40 bg-white" aria-labelledby="contactHeading">
      <div class="absolute w-full h-1/2 bg-gray-50" aria-hidden="true" />
      <div class="relative px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <svg
          class="absolute top-0 right-0 transform translate-x-1/2 -translate-y-16 sm:translate-x-1/4 md:-translate-y-24 lg:-translate-y-72"
          width="404"
          height="384"
          fill="none"
          viewBox="0 0 404 384"
          aria-hidden="true"
        >
          <defs>
            <pattern
              id="64e643ad-2176-4f86-b3d7-f2c5da3b6a6d"
              x="0"
              y="0"
              width="20"
              height="20"
              patternUnits="userSpaceOnUse"
            >
              <rect x="0" y="0" width="4" height="4" class="text-gray-200" fill="currentColor" />
            </pattern>
          </defs>
          <rect width="404" height="384" fill="url(#64e643ad-2176-4f86-b3d7-f2c5da3b6a6d)" />
        </svg>
      </div>
      <div class="px-4 mx-auto max-w-7xl sm:px-6 lg:px-8">
        <div class="relative bg-white shadow-xl">
          <h2 id="contactHeading" class="sr-only">Contact us</h2>

          <div class="grid grid-cols-1 lg:grid-cols-3">
            <div class="relative px-6 py-10 overflow-hidden bg-gradient-to-b from-yellow-500 to-yellow-600 sm:px-10 xl:p-12">
              <div class="absolute inset-0 pointer-events-none sm:hidden" aria-hidden="true">
                <svg
                  class="absolute inset-0 w-full h-full"
                  width="343"
                  height="388"
                  viewBox="0 0 343 388"
                  fill="none"
                  preserveAspectRatio="xMidYMid slice"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M-99 461.107L608.107-246l707.103 707.107-707.103 707.103L-99 461.107z"
                    fill="url(#linear1)"
                    fill-opacity=".1"
                  />
                  <defs>
                    <linearGradient
                      id="linear1"
                      x1="254.553"
                      y1="107.554"
                      x2="961.66"
                      y2="814.66"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stop-color="#fff" />
                      <stop offset="1" stop-color="#fff" stop-opacity="0" />
                    </linearGradient>
                  </defs>
                </svg>
              </div>
              <div
                class="absolute top-0 bottom-0 right-0 hidden w-1/2 pointer-events-none sm:block lg:hidden"
                aria-hidden="true"
              >
                <svg
                  class="absolute inset-0 w-full h-full"
                  width="359"
                  height="339"
                  viewBox="0 0 359 339"
                  fill="none"
                  preserveAspectRatio="xMidYMid slice"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M-161 382.107L546.107-325l707.103 707.107-707.103 707.103L-161 382.107z"
                    fill="url(#linear2)"
                    fill-opacity=".1"
                  />
                  <defs>
                    <linearGradient
                      id="linear2"
                      x1="192.553"
                      y1="28.553"
                      x2="899.66"
                      y2="735.66"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stop-color="#fff" />
                      <stop offset="1" stop-color="#fff" stop-opacity="0" />
                    </linearGradient>
                  </defs>
                </svg>
              </div>
              <div
                class="absolute top-0 bottom-0 right-0 hidden w-1/2 pointer-events-none lg:block"
                aria-hidden="true"
              >
                <svg
                  class="absolute inset-0 w-full h-full"
                  width="160"
                  height="678"
                  viewBox="0 0 160 678"
                  fill="none"
                  preserveAspectRatio="xMidYMid slice"
                  xmlns="http://www.w3.org/2000/svg"
                >
                  <path
                    d="M-161 679.107L546.107-28l707.103 707.107-707.103 707.103L-161 679.107z"
                    fill="url(#linear3)"
                    fill-opacity=".1"
                  />
                  <defs>
                    <linearGradient
                      id="linear3"
                      x1="192.553"
                      y1="325.553"
                      x2="899.66"
                      y2="1032.66"
                      gradientUnits="userSpaceOnUse"
                    >
                      <stop stop-color="#fff" />
                      <stop offset="1" stop-color="#fff" stop-opacity="0" />
                    </linearGradient>
                  </defs>
                </svg>
              </div>
              <h3 class="text-lg font-medium text-white">Contact information</h3>
              <p class="max-w-3xl mt-6 text-base text-yellow-50" />
              <dl class="mt-8 space-y-6">
                <dt><span class="sr-only">Phone number</span></dt>
                <dt><span class="sr-only">Email</span></dt>
                <dd class="flex text-base text-yellow-50">
                  <svg
                    class="flex-shrink-0 w-6 h-6 text-yellow-200"
                    xmlns="http://www.w3.org/2000/svg"
                    fill="none"
                    viewBox="0 0 24 24"
                    stroke="currentColor"
                    aria-hidden="true"
                  >
                    <path
                      stroke-linecap="round"
                      stroke-linejoin="round"
                      stroke-width="2"
                      d="M3 8l7.89 5.26a2 2 0 002.22 0L21 8M5 19h14a2 2 0 002-2V7a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z"
                    />
                  </svg>
                  <span class="ml-3">{System.get_env("SUPPORT_EMAIL")}</span>
                </dd>
              </dl>
            </div>

            <div class="px-6 py-10 sm:px-10 lg:col-span-2 xl:p-12">
              <div :if={@contact_form_submitted}>Message submitted. Thank you.</div>
              <div :if={!@contact_form_submitted}>
                <h3 class="text-lg font-medium text-gray-900">Send us a message</h3>
                <Form for={:contact} opts={phx_submit: "submit"}>
                  <div class="grid grid-cols-1 mt-6 gap-y-6 sm:grid-cols-2 sm:gap-x-8">
                    <div class="sm:col-span-2" :if={!@current_user}>
                      <FormField type="text" label="Name" field={:name} />
                    </div>
                    <div :if={!@current_user}>
                      <FormField type="text" label="Email" field={:email} />
                    </div>
                    <div :if={!@current_user}>
                      <FormField type="text" label="Phone (optional)" field={:phone} />
                    </div>
                    <div class="sm:col-span-2">
                      <FormField type="text" label="Subject" field={:subject} />
                    </div>
                    <div class="sm:col-span-2">
                      <FormField type="textarea" label="Message" field={:message} />
                    </div>
                    <div class="sm:col-span-2 sm:flex sm:justify-end">
                      <button
                        type="submit"
                        class="inline-flex items-center justify-center w-full px-6 py-3 mt-2 text-base font-medium text-white bg-yellow-500 border border-transparent rounded-md shadow-sm hover:bg-yellow-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-yellow-500 sm:w-auto"
                      >
                        Submit
                      </button>
                    </div>
                  </div>
                </Form>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>
    """
  end

  def handle_event("submit", %{"contact" => params}, socket) do
    UserNotifier.deliver_contact_form(params, socket.assigns[:current_user])
    {:noreply, assign(socket, %{contact_form_submitted: true})}
  end
end
