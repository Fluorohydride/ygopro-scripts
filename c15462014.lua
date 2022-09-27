--龍馬躓図
function c15462014.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCondition(c15462014.actcon)
	c:RegisterEffect(e1)
	--disable
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_DISABLE)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c15462014.distg)
	c:RegisterEffect(e2)
	--send to GY
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOGRAVE+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetCondition(c15462014.tgcon)
	e3:SetTarget(c15462014.tgtg)
	e3:SetOperation(c15462014.tgop)
	c:RegisterEffect(e3)
end
function c15462014.cfilter(c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c15462014.actcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(c15462014.cfilter,tp,LOCATION_MZONE,0,1,nil)
		and Duel.IsExistingMatchingCard(c15462014.cfilter,tp,0,LOCATION_MZONE,1,nil)
end
function c15462014.distg(e,c)
	return c:IsSummonLocation(LOCATION_EXTRA)
end
function c15462014.egfilter(c)
	local d=c:GetBattleTarget()
	return c:IsSummonLocation(LOCATION_EXTRA) and d:IsSummonLocation(LOCATION_EXTRA)
end
function c15462014.pcheck(c,tp)
	return c:IsPreviousControler(tp)
end
function c15462014.tgcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c15462014.egfilter,1,nil)
end
function c15462014.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,e:GetHandler(),1,0,0)
	local tg,pct,player=eg:Filter(c15462014.egfilter,nil),0,0
	for p=0,1 do
		if tg:IsExists(c15462014.pcheck,1,nil,p) then
			pct=pct+1
			player=p
		end
	end
	if pct==2 then player=PLAYER_ALL end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,player,1000)
end
function c15462014.tgop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SendtoGrave(c,REASON_EFFECT)
		local tg=eg:Filter(c15462014.egfilter,nil)
		for p=0,1 do
			if tg:IsExists(c15462014.pcheck,1,nil,p) then
				Duel.Damage(p,1000,REASON_EFFECT,true)
			end
		end
		Duel.RDComplete()
	end
end
