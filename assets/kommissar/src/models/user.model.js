import axios from 'axios'

class User {
  constructor (params) {
    Object.assign(this, params)
  }

  save () {
    const { id, serialized } = this

    let response
    if (id) {
      response = this.constructor.api().patch(`/${id}`, { user: serialized })
        .then(({ data }) => Object.assign(this, data.data))
    } else {
      response = this.constructor.api().post('', { user: serialized })
        .then(({ data }) => Object.assign(this, data.data))
    }

    return response.catch((error) => {
      const { errors } = error.response.data
      this.errors = errors
      throw errors
    })
  }

  get serialized () {
    const { username, password } = this
    return { username, password }
  }
}

User.api = function () {
  const baseURL = `${process.env.VUE_APP_KOMMISSAR_API_URL}/api/users`
  return axios.create({
    baseURL
  })
}

export default User
