<script setup lang="ts">
const { locale, locales, setLocale } = useI18n()

const items = computed(() =>
  (locales.value as { code: string, name: string }[]).map(l => ({
    label: l.name,
    type: 'checkbox' as const,
    checked: l.code === locale.value,
    onSelect: () => setLocale(l.code)
  }))
)
</script>

<template>
  <UDropdownMenu
    :items="items"
    :content="{ align: 'end' }"
  >
    <UButton
      icon="i-lucide-languages"
      color="neutral"
      variant="ghost"
      size="sm"
      class="rounded-full"
      aria-label="Change Language"
    />
  </UDropdownMenu>
</template>
