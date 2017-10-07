--The despair URANUS
function c32588805.initial_effect(c)
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(32588805,0))
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e1:SetCode(EVENT_SUMMON_SUCCESS)
	e1:SetCondition(c32588805.setcon)
	e1:SetTarget(c32588805.settg)
	e1:SetOperation(c32588805.setop)
	c:RegisterEffect(e1)
	--atkup
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_UPDATE_ATTACK)
	e2:SetRange(LOCATION_MZONE)
	e2:SetValue(c32588805.atkval)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD)
	e3:SetCode(EFFECT_INDESTRUCTABLE_EFFECT)
	e3:SetRange(LOCATION_MZONE)
	e3:SetTargetRange(LOCATION_SZONE,0)
	e3:SetTarget(c32588805.indtg)
	e3:SetValue(1)
	c:RegisterEffect(e3)
end
function c32588805.setcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_ADVANCE)
		and not Duel.IsExistingMatchingCard(Card.IsType,tp,LOCATION_ONFIELD,0,1,nil,TYPE_SPELL+TYPE_TRAP)
end
function c32588805.setfilter1(c)
	return c:IsType(TYPE_CONTINUOUS) and c:IsSSetable()
end
function c32588805.settg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_SZONE)>0
		and Duel.IsExistingMatchingCard(c32588805.setfilter1,tp,LOCATION_DECK,0,1,nil) end
end
function c32588805.setfilter2(c,typ)
	return c:GetType()==typ and c:IsSSetable()
end
function c32588805.setop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_SZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,1-tp,HINTMSG_OPTION)
	local op=Duel.SelectOption(1-tp,71,72)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	local g=nil
	if op==0 then g=Duel.SelectMatchingCard(tp,c32588805.setfilter2,tp,LOCATION_DECK,0,1,1,nil,TYPE_SPELL+TYPE_CONTINUOUS)
	else g=Duel.SelectMatchingCard(tp,c32588805.setfilter2,tp,LOCATION_DECK,0,1,1,nil,TYPE_TRAP+TYPE_CONTINUOUS) end
	if g:GetCount()>0 then
		Duel.SSet(tp,g:GetFirst())
		Duel.ConfirmCards(1-tp,g)
	end
end
function c32588805.atkfilter(c)
	return c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsFaceup()
end
function c32588805.atkval(e,c)
	return Duel.GetMatchingGroupCount(c32588805.atkfilter,e:GetHandlerPlayer(),LOCATION_ONFIELD,0,nil)*300
end
function c32588805.indtg(e,c)
	return c:GetSequence()<5 and c:IsFaceup()
end
