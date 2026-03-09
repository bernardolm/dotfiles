function getElementsByText(str, tag = 'a') {
  return Array.prototype.slice.call(
    document.getElementsByTagName(tag)
  ).filter(el =>
    el.textContent.trim() === str.trim()
  );
};

document.querySelectorAll('li.reusable-search__result-container button.artdeco-dropdown__trigger--placement-bottom').forEach(el =>
  el.click());

await new Promise(r => setTimeout(r, 500));

getElementsByText('Remover vaga', 'span').forEach(el =>
  el.click());
