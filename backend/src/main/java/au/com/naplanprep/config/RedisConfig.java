package au.com.naplanprep.config;

import lombok.extern.slf4j.Slf4j;
import org.springframework.cache.Cache;
import org.springframework.cache.annotation.EnableCaching;
import org.springframework.cache.interceptor.CacheErrorHandler;
import org.springframework.cache.annotation.CachingConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.data.redis.cache.RedisCacheConfiguration;
import org.springframework.data.redis.cache.RedisCacheManager;
import org.springframework.data.redis.connection.RedisConnectionFactory;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.data.redis.serializer.GenericJackson2JsonRedisSerializer;
import org.springframework.data.redis.serializer.JdkSerializationRedisSerializer;
import org.springframework.data.redis.serializer.RedisSerializationContext.SerializationPair;
import org.springframework.data.redis.serializer.StringRedisSerializer;

import java.time.Duration;

@Slf4j
@Configuration
@EnableCaching
public class RedisConfig implements CachingConfigurer {

    @Bean
    public RedisTemplate<String, String> redisTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, String> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new StringRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new StringRedisSerializer());
        template.afterPropertiesSet();
        return template;
    }

    @Bean
    public RedisTemplate<String, Object> redisObjectTemplate(RedisConnectionFactory factory) {
        RedisTemplate<String, Object> template = new RedisTemplate<>();
        template.setConnectionFactory(factory);
        template.setKeySerializer(new StringRedisSerializer());
        template.setValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.setHashKeySerializer(new StringRedisSerializer());
        template.setHashValueSerializer(new GenericJackson2JsonRedisSerializer());
        template.afterPropertiesSet();
        return template;
    }

    @Bean
    public RedisCacheManager cacheManager(RedisConnectionFactory factory) {
        SerializationPair<String> keyPair = SerializationPair.fromSerializer(new StringRedisSerializer());
        SerializationPair<Object> jsonPair = SerializationPair.fromSerializer(new GenericJackson2JsonRedisSerializer());
        // Use JDK serialization for UserDetails — Spring Security's User class is Serializable
        // and avoids Jackson type-resolution issues with final classes
        SerializationPair<Object> jdkPair = SerializationPair.fromSerializer(new JdkSerializationRedisSerializer());

        RedisCacheConfiguration jsonBase = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(5))
            .disableCachingNullValues()
            .serializeKeysWith(keyPair)
            .serializeValuesWith(jsonPair);

        RedisCacheConfiguration jdkBase = RedisCacheConfiguration.defaultCacheConfig()
            .entryTtl(Duration.ofMinutes(5))
            .disableCachingNullValues()
            .serializeKeysWith(keyPair)
            .serializeValuesWith(jdkPair);

        return RedisCacheManager.builder(factory)
            .cacheDefaults(jsonBase)
            .withCacheConfiguration("userDetails", jdkBase.entryTtl(Duration.ofMinutes(5)))
            .withCacheConfiguration("questions",   jsonBase.entryTtl(Duration.ofMinutes(30)))
            .withCacheConfiguration("examCatalog", jsonBase.entryTtl(Duration.ofMinutes(2)))
            .build();
    }

    /** Silently log cache errors and fall through to the real method — keeps the app alive if Redis is down. */
    @Override
    public CacheErrorHandler errorHandler() {
        return new CacheErrorHandler() {
            @Override
            public void handleCacheGetError(RuntimeException e, Cache cache, Object key) {
                log.warn("Cache GET error [{}/{}]: {}", cache.getName(), key, e.getMessage());
            }
            @Override
            public void handleCachePutError(RuntimeException e, Cache cache, Object key, Object value) {
                log.warn("Cache PUT error [{}/{}]: {}", cache.getName(), key, e.getMessage());
            }
            @Override
            public void handleCacheEvictError(RuntimeException e, Cache cache, Object key) {
                log.warn("Cache EVICT error [{}/{}]: {}", cache.getName(), key, e.getMessage());
            }
            @Override
            public void handleCacheClearError(RuntimeException e, Cache cache) {
                log.warn("Cache CLEAR error [{}]: {}", cache.getName(), e.getMessage());
            }
        };
    }
}
