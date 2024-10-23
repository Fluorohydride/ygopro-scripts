--超信地旋回
function c22866836.initial_effect(c)
	--destroy monster
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(22866836,0))
	e1:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER)
	e1:SetTarget(c22866836.target1)
	e1:SetOperation(c22866836.operation1)
	c:RegisterEffect(e1)
	--destroy s&t
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(22866836,1))
	e2:SetCategory(CATEGORY_POSITION+CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetHintTiming(0,TIMING_END_PHASE)
	e2:SetTarget(c22866836.target2)
	e2:SetOperation(c22866836.operation2)
	c:RegisterEffect(e2)
end
function c22866836.tgfilter1(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP_ATTACK) and c:IsCanChangePosition()
end
function c22866836.target1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_MZONE,1,nil)
		and Duel.IsExistingTarget(c22866836.tgfilter1,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pg=Duel.SelectTarget(tp,c22866836.tgfilter1,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,pg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c22866836.operation1(e,tp,eg,ep,ev,re,r,rp)
	local ex1,pg=Duel.GetOperationInfo(0,CATEGORY_POSITION)
	local ex2,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local pc=pg:GetFirst()
	local dc=dg:GetFirst()
	if pc:IsRelateToEffect(e) and dc:IsRelateToEffect(e)
		and pc:IsControler(tp)
		and Duel.ChangePosition(pc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and dc:IsControler(1-tp) then
		Duel.Destroy(dc,REASON_EFFECT)
	end
end
function c22866836.tgfilter2(c)
	return c:IsRace(RACE_MACHINE) and c:IsAttribute(ATTRIBUTE_EARTH)
		and c:IsType(TYPE_XYZ) and c:IsPosition(POS_FACEUP_DEFENSE) and c:IsCanChangePosition()
end
function c22866836.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return false end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,0,LOCATION_SZONE,1,nil)
		and Duel.IsExistingTarget(c22866836.tgfilter2,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
	local pg=Duel.SelectTarget(tp,c22866836.tgfilter2,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local dg=Duel.SelectTarget(tp,nil,tp,0,LOCATION_SZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,pg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,dg,1,0,0)
end
function c22866836.operation2(e,tp,eg,ep,ev,re,r,rp)
	local ex1,pg=Duel.GetOperationInfo(0,CATEGORY_POSITION)
	local ex2,dg=Duel.GetOperationInfo(0,CATEGORY_DESTROY)
	local pc=pg:GetFirst()
	local dc=dg:GetFirst()
	if pc:IsRelateToEffect(e) and dc:IsRelateToEffect(e)
		and pc:IsControler(tp)
		and Duel.ChangePosition(pc,POS_FACEUP_DEFENSE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK)~=0
		and dc:IsControler(1-tp) then
		Duel.Destroy(dc,REASON_EFFECT)
	end
end
