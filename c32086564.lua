--エクシーズ・トライバル
function c32086564.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e2:SetRange(LOCATION_SZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(c32086564.target)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(32086564,0))
	e3:SetCategory(CATEGORY_DESTROY)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e3:SetCode(EVENT_BATTLED)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c32086564.destg)
	e3:SetOperation(c32086564.desop)
	c:RegisterEffect(e3)
end
function c32086564.target(e,c)
	return c:GetOverlayCount()>=2
end
function c32086564.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a,d=Duel.GetBattleMonster(tp)
	if chk==0 then return a and d and a:GetOverlayCount()>=2 end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
end
function c32086564.desop(e,tp,eg,ep,ev,re,r,rp)
	local a,d=Duel.GetBattleMonster(tp)
	if a and d and a:IsRelateToBattle() and d:IsRelateToBattle() and a:GetOverlayCount()>=2 then
		Duel.Destroy(d,REASON_EFFECT)
	end
end
