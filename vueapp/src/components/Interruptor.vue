<template>
  <div>
    <p>Interruptor is {{ enabled }}</p>
    <hr/>
    <input type="checkbox" v-model="enabled" v-on:change="toggleEnabled"></input>
  </div>
</template>

<script>
import { mapState, mapActions } from 'vuex';

export default {
  name: 'interruptor',
  computed: mapState({
    enabled: state => state.enabled
  }),
  methods: {
    ...mapActions(['toggleEnabled'])
  }
}
</script>
