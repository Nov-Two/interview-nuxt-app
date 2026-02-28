<script setup lang="ts">
const { t } = useI18n()

const links = computed(() => [
  { label: t('nav.home'), icon: 'i-lucide-home', to: '/' },
  { label: t('nav.projects'), icon: 'i-lucide-folder', to: '/projects' },
  // { label: t('nav.blog'), icon: 'i-lucide-file-text', to: '/blog' },
  // { label: t('nav.speaking'), icon: 'i-lucide-mic', to: '/speaking' },
  { label: t('nav.about'), icon: 'i-lucide-user', to: '/about' }
])
</script>

<template>
  <div>
    <UContainer class="sm:border-x border-default pt-10">
      <AppHeader :links="links" />
      <slot />
      <AppFooter />
    </UContainer>
  </div>
</template>
