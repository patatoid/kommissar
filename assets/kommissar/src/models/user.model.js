import axios from 'axios'
import jwt from 'jsonwebtoken'

const ACCESS_TOKEN_KEY = 'access_token'

class User {
  constructor (params) {
    this.token = localStorage.getItem('access_token')
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

  login () {
    const { username, password } = this

    return this.constructor.api().post('/login', { username, password })
      .then(({ data: { access_token: token, data } }) => {
        localStorage.setItem(ACCESS_TOKEN_KEY, token)
        return Object.assign(this, { token, ...data })
      })
      .catch((error) => {
        throw error.response.data
      })
  }

  logout () {
    localStorage.removeItem(ACCESS_TOKEN_KEY)
  }

  get isAuthenticated () {
    try {
      const { exp } = jwt.decode(this.token)
      return exp > Math.floor(Date.now() / 1000)
    } catch (error) {
      return false
    }
  }

  get serialized () {
    const { username, password } = this
    return { username, password }
  }
}

User.api = function () {
  const baseURL = `${process.env.VUE_APP_KOMMISSAR_API_URL}/api/users`
  const accessToken = localStorage.getItem('access_token')

  return axios.create({
    baseURL,
    headers: { 'Authorization': `Bearer ${accessToken}` }
  })
}

User.current = function () {
  return this.api().get('/me')
    .then(({ data }) => Object.assign(new User(), data.data))
    .catch(() => new User())
}

export default User
