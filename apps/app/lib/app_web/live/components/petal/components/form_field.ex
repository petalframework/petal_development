defmodule AppWeb.Petal.Components.FormField do
  # https://surface-ui.org/builtincomponents/InputControls

  use AppWeb, :surface_component
  alias Surface.Components.Form.Input.InputContext

  prop type, :string,
    default: "text",
    values: [
      "text",
      "email",
      "url",
      "number",
      "password",
      "select",
      "checkbox",
      "date",
      "radio",
      "phone",
      "color",
      "file"
    ]

  # --- These props apply to all fields ---
  prop field, :atom
  prop label, :string
  prop label_class, :css_class
  prop value, :any
  prop help_text, :string
  prop no_margin, :boolean, default: false
  prop input_additional_class, :css_class

  # Sets a phx-debounce attribute on the input element
  prop debounce, :string, default: ""

  # These options get passed to the underlying input field
  prop opts, :list, default: []

  # --- These props are field dependant ---
  # Text related
  prop autofocus, :boolean, default: false
  prop placeholder, :string
  prop autocomplete, :boolean, default: true

  # Textarea related
  prop rows, :integer, default: 4
  prop auto_resize, :boolean, default: false

  # Checkbox related
  prop checked_value, :any

  # Select related
  prop select_options, :any, default: []
  prop selected, :any

  # Datetime related

  # https://flatpickr.js.org/options/
  prop datetime_opts, :map, default: %{}

  def render(assigns) do
    ~F"""
    <Field name={@field} class={"mb-5": !@no_margin}>
      <InputContext assigns={assigns} :let={form: form, field: field}>
        <Label class={label_css(), @label_class} :if={@label && !label_not_on_top?(@type)}>
          {@label}
        </Label>

        <TextInput
          :if={@type == "text"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <EmailInput
          :if={@type == "email"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <UrlInput
          :if={@type == "url"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <NumberInput
          :if={@type == "number"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <TelephoneInput
          :if={@type == "phone"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <PasswordInput
          :if={@type == "password"}
          value={@value}
          opts={generate_text_field_options(assigns)}
          class={input_css(field_has_errors?(form, field)), @input_additional_class}
        />

        <Select
          :if={@type == "select"}
          options={@select_options}
          selected={@selected}
          opts={@opts}
          class={select_css(field_has_errors?(form, field))}
        />

        <FileInput
          :if={@type == "file"}
          value={@value}
          class={@input_additional_class}
          opts={@opts ++ [phx_debounce: @debounce]}
        />

        <div
          :if={@type == "textarea"}
          class={"relative mt-1 rounded-md shadow-sm", @input_additional_class}
        >
          <TextArea
            value={@value}
            opts={generate_text_field_options(assigns)}
            rows={@rows}
            class={textarea_css(field_has_errors?(form, field))}
          />
        </div>

        <div :if={@type == "checkbox"} class="relative flex items-start">
          <div class="flex items-center h-5">
            <Checkbox
              :if={@type == "checkbox"}
              value={@value}
              checked_value={@checked_value}
              opts={@opts}
              class={checkbox_css()}
            />
          </div>
          <div class="ml-3 text-sm">
            <Label class={label_css(), @label_class}>
              {@label}
            </Label>
          </div>
        </div>

        <div :if={@type == "datetime"} class="mt-1 rounded-md shadow-sm">
          <HiddenInput
            value={@value}
            opts={@opts ++
              [
                phx_debounce: "blur",
                "phx-hook": "FlatpickrHook",
                "data-flatpickr-opts": Jason.encode!(@datetime_opts)
              ]}
            class={input_css(field_has_errors?(form, field))}
          />
        </div>

        <div :if={@type == "radio"} class="mt-4 space-y-4">
          <label :for={option <- @select_options} class="flex items-center gap-3 text-sm text-gray-700">
            <RadioButton
              value={elem(option, 1)}
              checked={@value == elem(option, 1)}
              class="w-4 h-4 border-gray-300 text-primary-600 focus:ring-primary-500"
            />
            {elem(option, 0)}
          </label>
        </div>

        <ColorInput :if={@type == "color"} value={@value} opts={@opts ++ [phx_debounce: @debounce]} />

        <div :if={@help_text} class="mt-1.5 text-xs text-gray-500 dark:text-gray-400">{@help_text}</div>

        <ErrorTag class="error-text" />
      </InputContext>
    </Field>
    """
  end

  def generate_text_field_options(assigns) do
    options =
      Keyword.merge(
        [
          phx_debounce: assigns[:debounce],
          placeholder: assigns[:placeholder],
          autocomplete: if(assigns[:autocomplete], do: "on", else: "off")
        ],
        assigns[:opts]
      )

    if assigns[:autofocus] do
      Keyword.merge(["x-data": "{}", "x-init": "$nextTick(() => {$el.focus()})"], options)
    else
      options
    end
  end

  def label_not_on_top?(type),
    do:
      Enum.member?(
        [
          "checkbox"
        ],
        type
      )

  def maybe_auto_resize(true),
    do: "() => {new TextareaAutoResize( $el.querySelector('textarea'))}"

  def maybe_auto_resize(false), do: ""
end
