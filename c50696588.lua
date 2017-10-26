--GUYダンス
function c50696588.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCost(c50696588.cost)
	e1:SetTarget(c50696588.target)
	e1:SetOperation(c50696588.activate)
	c:RegisterEffect(e1)
end
function c50696588.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,50696588)==0 end
end
function c50696588.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(1-tp,LOCATION_MZONE,PLAYER_NONE,0)>0 end
	local flag=Duel.SelectDisableField(1-tp,1,LOCATION_MZONE,0,bit.bnot(bit.rshift(Duel.SelectDisableField(tp,1,0,LOCATION_MZONE,0),16)))
	e:SetLabel(flag)
end
function c50696588.activate(e,tp,eg,ep,ev,re,r,rp)
	local flag=e:GetLabel()
	local seq=math.log(flag,2)
	if not Duel.CheckLocation(1-tp,LOCATION_MZONE,seq) then return end
	Duel.RegisterFlagEffect(tp,50696588,0,0,0)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_MUST_USE_MZONE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(0,1)
	e1:SetValue(flag)
	Duel.RegisterEffect(e1,tp)
end
