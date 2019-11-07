--ゴーストリックの妖精
function c36239585.initial_effect(c)
	--summon limit
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_CANNOT_SUMMON)
	e1:SetCondition(c36239585.sumcon)
	c:RegisterEffect(e1)
	--turn set
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36239585,0))
	e2:SetCategory(CATEGORY_POSITION)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTarget(c36239585.postg)
	e2:SetOperation(c36239585.posop)
	c:RegisterEffect(e2)
	--set card
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(36239585,1))
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_FLIP)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetTarget(c36239585.settg)
	e3:SetOperation(c36239585.setop)
	c:RegisterEffect(e3)
end
function c36239585.sfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x8d)
end
function c36239585.sumcon(e)
	return not Duel.IsExistingMatchingCard(c36239585.sfilter,e:GetHandlerPlayer(),LOCATION_MZONE,0,1,nil)
end
function c36239585.postg(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsCanTurnSet() and c:GetFlagEffect(36239585)==0 end
	c:RegisterFlagEffect(36239585,RESET_EVENT+RESETS_STANDARD-RESET_TURN_SET+RESET_PHASE+PHASE_END,0,1)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,c,1,0,0)
end
function c36239585.posop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) and c:IsFaceup() then
		Duel.ChangePosition(c,POS_FACEDOWN_DEFENSE)
	end
end
function c36239585.spfilter(c,e,tp)
	return c:IsSetCard(0x8d) and c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE)
end
function c36239585.sefilter(c)
	return c:IsSetCard(0x8d) and c:IsSSetable()
end
function c36239585.setfilter(c,e,tp)
	return c:IsSetCard(0x8d) and (c:IsCanBeSpecialSummoned(e,0,tp,false,false,POS_FACEDOWN_DEFENSE) or c:IsSSetable())
end
function c36239585.posfilter(c)
	return c:IsFaceup() and c:IsCanTurnSet()
end
function c36239585.settg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp)
		and (c36239585.spfilter(chkc,e,tp) or c36239585.sefilter(chkc)) end
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sz=Duel.GetLocationCount(tp,LOCATION_SZONE)
	local b1=mz>0 and Duel.IsExistingTarget(c36239585.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp)
	local b2=sz>0 and Duel.IsExistingTarget(c36239585.sefilter,tp,LOCATION_GRAVE,0,1,nil)
	if chk==0 then return b1 or b2 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SET)
	if b1 and not b2 then
		local g=Duel.SelectTarget(tp,c36239585.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		local cat=e:GetCategory()
		e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
		Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
	end
	if not b1 and b2 then
		Duel.SelectTarget(tp,c36239585.sefilter,tp,LOCATION_GRAVE,0,1,1,nil)
	end
	if b1 and b2 then
		local g=Duel.SelectTarget(tp,c36239585.setfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
		if bit.band(g:GetFirst():GetOriginalType(),TYPE_MONSTER)~=0 then
			local cat=e:GetCategory()
			e:SetCategory(bit.bor(cat,CATEGORY_SPECIAL_SUMMON))
			Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
		end
	end
end
function c36239585.setop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if not tc:IsRelateToEffect(e) then return end
	local ty=tc:GetOriginalType()
	local mz=Duel.GetLocationCount(tp,LOCATION_MZONE)
	local sz=Duel.GetLocationCount(tp,LOCATION_SZONE)
	if (mz<=0 and bit.band(ty,TYPE_MONSTER)~=0) or (sz<=0 and bit.band(ty,TYPE_SPELL+TYPE_TRAP)~=0) then return end
	local set=0
	if mz>0 and bit.band(ty,TYPE_MONSTER)~=0 then
		set=Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEDOWN_DEFENSE)
		Duel.ConfirmCards(1-tp,tc)
	end
	if sz>0 and bit.band(ty,TYPE_SPELL+TYPE_TRAP)~=0 then
		set=Duel.SSet(tp,tc)
		Duel.ConfirmCards(1-tp,tc)
	end
	if set~=0 then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_LEAVE_FIELD_REDIRECT)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetReset(RESET_EVENT+RESETS_REDIRECT)
		e1:SetValue(LOCATION_REMOVED)
		tc:RegisterEffect(e1,true)
	end
	if set~=0 and Duel.IsExistingMatchingCard(Card.IsPosition,tp,LOCATION_ONFIELD,0,1,nil,POS_FACEDOWN)
		and Duel.IsExistingMatchingCard(c36239585.posfilter,tp,0,LOCATION_MZONE,1,nil)
		and Duel.SelectYesNo(tp,aux.Stringid(36239585,2)) then
		Duel.BreakEffect()
		local gc=Duel.GetMatchingGroupCount(Card.IsPosition,tp,LOCATION_ONFIELD,0,nil,POS_FACEDOWN)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_POSCHANGE)
		local g=Duel.SelectMatchingCard(tp,c36239585.posfilter,tp,0,LOCATION_MZONE,1,gc,nil)
		Duel.HintSelection(g)
		Duel.ChangePosition(g,POS_FACEDOWN_DEFENSE)
	end
end
