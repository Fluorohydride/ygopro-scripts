--カース・オブ・スタチュー
---@param c Card
function c3129635.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,TIMING_END_PHASE)
	e1:SetTarget(c3129635.target)
	e1:SetOperation(c3129635.activate)
	c:RegisterEffect(e1)
	--destroy
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(3129635,0))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_BATTLED)
	e2:SetCondition(c3129635.descon)
	e2:SetTarget(c3129635.destg)
	e2:SetOperation(c3129635.desop)
	c:RegisterEffect(e2)
end
function c3129635.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:IsCostChecked()
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsPlayerCanSpecialSummonMonster(tp,3129635,0,TYPES_EFFECT_TRAP_MONSTER,1800,1000,4,RACE_ROCK,ATTRIBUTE_DARK) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function c3129635.activate(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not Duel.IsPlayerCanSpecialSummonMonster(tp,3129635,0,TYPES_EFFECT_TRAP_MONSTER,1800,1000,4,RACE_ROCK,ATTRIBUTE_DARK) then return end
	c:AddMonsterAttribute(TYPE_EFFECT+TYPE_TRAP)
	Duel.SpecialSummon(c,SUMMON_VALUE_SELF,tp,tp,true,false,POS_FACEUP)
end
function c3129635.descon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetSummonType()==SUMMON_TYPE_SPECIAL+SUMMON_VALUE_SELF
end
function c3129635.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	if chk==0 then
		if a:IsControler(tp) then return d and a~=e:GetHandler() and bit.band(a:GetOriginalType(),TYPE_TRAP)~=0
		else return d and d~=e:GetHandler() and bit.band(d:GetOriginalType(),TYPE_TRAP)~=0 end
	end
	if a:IsControler(tp) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,d,1,0,0)
		e:SetLabelObject(d)
	else
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,a,1,0,0)
		e:SetLabelObject(a)
	end
end
function c3129635.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=e:GetLabelObject()
	if tc:IsRelateToBattle() then
		Duel.Destroy(tc,REASON_EFFECT)
	end
end
