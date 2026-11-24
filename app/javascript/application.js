// Entry point for the build script in your package.json
import "@hotwired/turbo-rails";
import { initAll } from "govuk-frontend";

initAll();

document.addEventListener("click", (event) => {
	const link = event.target.closest("[data-open-in-new-tab]");
	if (!link) return;

	window.open(link.dataset.openInNewTab, "_blank", "noopener");
});
