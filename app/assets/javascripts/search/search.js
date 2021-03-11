document.addEventListener("turbolinks:load", function () {
    $input = $("[data-behavior='autocomplete']")

    let element = document.querySelector("meta[name='current-account']")
    if (element == null) return
    let current_account = element.getAttribute("content")

    var options = {
        getValue: "name",
        url: function (phrase) {
            return "/" + current_account + "/search?q=" + phrase;
        },
        categories: [
            {
                listLocation: "projects",
                header: "<strong>Projects</strong>",
            },
            {
                listLocation: "employees",
                header: "<strong>Employees</strong>",
            }
        ],
        list: {
            onChooseEvent: function () {
                var url = $input.getSelectedItemData().url
                $input.val("")
                Turbolinks.visit(url)
            }
        }
    }

    $input.easyAutocomplete(options)
});
