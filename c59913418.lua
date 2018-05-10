--終焉の覇王デミス
function c59913418.initial_effect(c)
	c:EnableReviveLimit()
	--code
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e1:SetCode(EFFECT_CHANGE_CODE)
	e1:SetRange(LOCATION_MZONE+LOCATION_HAND)
	e1:SetValue(72426662)
	c:RegisterEffect(e1)
	--indes
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(LOCATION_MZONE,0)
	e2:SetCondition(c59913418.indcon)
	e2:SetTarget(c59913418.indtg)
	e2:SetValue(1)
	c:RegisterEffect(e2)
	--cost change
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_LPCOST_CHANGE)
	e0:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e0:SetRange(LOCATION_MZONE)
	e0:SetTargetRange(1,1)
	e0:SetCondition(c59913418.costcon)
	e0:SetValue(c59913418.costval)
	c:RegisterEffect(e0)
	--destroy
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetCost(c59913418.descost)
	e3:SetTarget(c59913418.destg)
	e3:SetOperation(c59913418.desop)
	c:RegisterEffect(e3)
end
function c59913418.indcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_RITUAL)
end
function c59913418.indtg(e,c)
	return c:IsType(TYPE_RITUAL)
end
function c59913418.mfilter(c)
	return not c:IsType(TYPE_RITUAL)
end
function c59913418.costcon(e)
	local c=e:GetHandler()
	local mg=c:GetMaterial()
	return c:GetSummonType()==SUMMON_TYPE_RITUAL and mg:GetCount()>0 and not mg:IsExists(c59913418.mfilter,1,nil)
end
function c59913418.costval(e,re,rp,val)
	if re and re:IsHasType(0x7e0) and re:GetHandler()==e:GetHandler() then
		return 0
	else return val end
end
function c59913418.descost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckLPCost(tp,2000) end
	Duel.PayLPCost(tp,2000)
end
function c59913418.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	local ct=g:FilterCount(Card.IsControler,nil,1-tp)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,g:GetCount(),0,0)
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,ct*200)
end
function c59913418.desop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(aux.TRUE,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	Duel.Destroy(g,REASON_EFFECT)
	local ct=Duel.GetOperatedGroup():FilterCount(Card.IsControler,nil,1-tp)
	if ct>0 then
		Duel.Damage(1-tp,ct*200,REASON_EFFECT)
	end
end
