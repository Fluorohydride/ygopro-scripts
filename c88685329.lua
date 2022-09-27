--ダークアイ・ナイトメア
function c88685329.initial_effect(c)
	--draw
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1,88685329)
	e1:SetCost(c88685329.drcost)
	e1:SetTarget(c88685329.drtg)
	e1:SetOperation(c88685329.drop)
	c:RegisterEffect(e1)
	--destroy replace
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e2:SetCode(EFFECT_DESTROY_REPLACE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c88685329.reptg)
	c:RegisterEffect(e2)
end
function c88685329.drfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemoveAsCost()
end
function c88685329.drcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c88685329.drfilter,tp,LOCATION_GRAVE,0,1,nil) end
	local ct=2
	if Duel.IsPlayerCanDraw(tp,2) then ct=3 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c88685329.drfilter,tp,LOCATION_GRAVE,0,1,ct,nil)
	e:SetLabel(Duel.Remove(g,POS_FACEUP,REASON_COST))
end
function c88685329.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	local label=e:GetLabel()
	if label==1 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_TODECK)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
		Duel.SetOperationInfo(0,CATEGORY_TODECK,nil,1,tp,LOCATION_HAND)
	elseif label==2 then
		e:SetCategory(CATEGORY_DRAW)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
	elseif label==3 then
		e:SetCategory(CATEGORY_DRAW+CATEGORY_HANDES)
		Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,2)
		Duel.SetOperationInfo(0,CATEGORY_HANDES,nil,0,tp,1)
	end
end
function c88685329.drop(e,tp,eg,ep,ev,re,r,rp)
	local label=e:GetLabel()
	if label==1 then
		if Duel.Draw(tp,1,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TODECK)
			local g=Duel.SelectMatchingCard(tp,Card.IsAbleToDeck,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoDeck(g,nil,SEQ_DECKTOP,REASON_EFFECT)
		end
	elseif label==2 then
		Duel.Draw(tp,1,REASON_EFFECT)
	elseif label==3 then
		if Duel.Draw(tp,2,REASON_EFFECT)~=0 then
			Duel.BreakEffect()
			Duel.ShuffleHand(tp)
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DISCARD)
			local g=Duel.SelectMatchingCard(tp,nil,tp,LOCATION_HAND,0,1,1,nil)
			Duel.SendtoGrave(g,REASON_EFFECT+REASON_DISCARD)
		end
	end
end
function c88685329.repfilter(c)
	return c:IsType(TYPE_TRAP) and c:IsAbleToRemove()
end
function c88685329.reptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReason(REASON_BATTLE) and Duel.IsExistingMatchingCard(c88685329.repfilter,tp,LOCATION_GRAVE,0,1,nil) end
	if Duel.SelectEffectYesNo(tp,e:GetHandler(),96) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
		local g=Duel.SelectMatchingCard(tp,c88685329.repfilter,tp,LOCATION_GRAVE,0,1,1,nil)
		Duel.Remove(g,POS_FACEUP,REASON_EFFECT+REASON_REPLACE)
		return true
	else return false end
end
