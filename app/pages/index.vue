<script setup lang="ts">
const { locale } = useI18n()

const { data: page } = await useAsyncData('index-page-data', () => {
  const collectionName = locale.value === 'zh' ? 'index_zh' : 'index'
  return queryCollection(collectionName as 'index').first()
}, {
  watch: [locale]
})
if (!page.value) {
  throw createError({
    statusCode: 404,
    statusMessage: 'Page not found',
    fatal: true
  })
}

useSeoMeta({
  title: page.value?.seo.title || page.value?.title,
  ogTitle: page.value?.seo.title || page.value?.title,
  description: page.value?.seo.description || page.value?.description,
  ogDescription: page.value?.seo.description || page.value?.description
})
</script>

<template>
  <UPage v-if="page">
    <LandingHero
      :key="locale"
      :page="page"
    />
    <UPageSection
      :ui="{
        container: '!pt-0 lg:grid lg:grid-cols-2 lg:gap-8'
      }"
    >
      <LandingAbout
        :key="locale"
        :page="page"
      />
      <LandingWorkExperience
        :key="locale"
        :page="page"
      />
    </UPageSection>
    <LandingBlog
      :key="locale"
      :page="page"
    />
    <LandingTestimonials
      :key="locale"
      :page="page"
    />
    <LandingFAQ
      :key="locale"
      :page="page"
    />
  </UPage>
</template>
