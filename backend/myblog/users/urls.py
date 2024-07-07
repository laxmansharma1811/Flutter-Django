from django.urls import path, include
from .views import RegisterView, CustomTokenObtainPairView, CustomTokenRefreshView, LogoutView
from .views import BlogPostViewSet
from rest_framework.routers import DefaultRouter

router = DefaultRouter()
router.register(r'blogposts', BlogPostViewSet)

urlpatterns = [
    path('register/', RegisterView.as_view(), name='register'),
    path('login/', CustomTokenObtainPairView.as_view(), name='token_obtain_pair'),
    path('token/refresh/', CustomTokenRefreshView.as_view(), name='token_refresh'),
    path('', include(router.urls)),
    path('api/logout/', LogoutView.as_view(), name='logout'),
]
