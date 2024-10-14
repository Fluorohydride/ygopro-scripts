--魂縛門
---@param c Card
function c6909330.initial_effect(c)
	--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetCondition(c6909330.condition)
	c:RegisterEffect(e0)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(6909330,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetRange(LOCATION_FZONE)
	e1:SetCondition(c6909330.descon)
	e1:SetTarget(c6909330.destg)
	e1:SetOperation(c6909330.desop)
	c:RegisterEffect(e1)
	local e2=e1:Clone()
	e2:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	c:RegisterEffect(e2)
	local e3=e1:Clone()
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	c:RegisterEffect(e3)
	if not c6909330.global_check then
		c6909330.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_DESTROYED)
		ge1:SetOperation(c6909330.regop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c6909330.filter(c)
	return c:IsPreviousLocation(LOCATION_ONFIELD) and c:IsPreviousPosition(POS_FACEDOWN) and c:GetPreviousTypeOnField()&(TYPE_SPELL+TYPE_TRAP)~=0
		and c:IsReason(REASON_EFFECT)
end
function c6909330.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=eg:Filter(c6909330.filter,nil)
	local tc=g:GetFirst()
	while tc do
		if Duel.GetFlagEffect(tc:GetPreviousControler(),6909330)==0 then
			Duel.RegisterFlagEffect(tc:GetPreviousControler(),6909330,RESET_PHASE+PHASE_END,0,1)
		end
		if Duel.GetFlagEffect(0,6909330)>0 and Duel.GetFlagEffect(1,6909330)>0 then
			break
		end
		tc=g:GetNext()
	end
end
function c6909330.condition(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFlagEffect(tp,6909330)>0 and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
end
function c6909330.descon(e,tp,eg,ep,ev,re,r,rp)
	local ph=Duel.GetCurrentPhase()
	if not (ph==PHASE_MAIN1 or ph==PHASE_MAIN2) then return false end
	if eg:GetCount()>1 then return false end
	local tc=eg:GetFirst()
	if not tc then return false end
	e:SetLabelObject(tc)
	return tc:IsLocation(LOCATION_MZONE) and tc:IsFaceup() and tc:GetAttack()<Duel.GetLP(tp)
		and Duel.IsExistingMatchingCard(Card.IsCode,tp,LOCATION_GRAVE,0,1,nil,62499965)
end
function c6909330.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	local tc=e:GetLabelObject()
	if chk==0 then return tc end
	Duel.SetTargetCard(tc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tc,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,800)
end
function c6909330.desop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.Destroy(tc,REASON_EFFECT)~=0 and Duel.Damage(tp,800,REASON_EFFECT)~=0 and Duel.GetLP(tp)>0 then
		Duel.BreakEffect()
		Duel.Damage(1-tp,800,REASON_EFFECT)
	end
end
