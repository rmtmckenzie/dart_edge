import 'package:cloudflare_workers/cloudflare_workers.dart';
import 'package:cloudflare_workers/public/request_init.dart';

class TestDo extends DurableObject {
  TestDo(super.name);

  @override
  FutureOr<Response> fetch(Request request) {
    print('in do');
    return Response('');
  }
}

void main() {
  CloudflareWorkers(
    durableObjects: [TestDo('StatsWorker')],
    fetch: (request, env, ctx) async {
      final durable = env.getDurableObjectNamespace('ZAPP_STATS_WORKER');
      final id = durable.idFromName('test');
      await durable.get(id).fetch(request);

      return Response('');
    },
  );
}
