--天霆號アーゼウス
---@param c Card
function c90448279.initial_effect(c)
	--xyz summon
	aux.AddXyzProcedure(c,nil,12,2,c90448279.ovfilter,aux.Stringid(90448279,0),2,c90448279.xyzop)
	c:EnableReviveLimit()
	--to grave
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(90448279,1))
	e1:SetCategory(CATEGORY_TOGRAVE)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetRange(LOCATION_MZONE)
	e1:SetHintTiming(0,TIMINGS_CHECK_MONSTER+TIMING_END_PHASE)
	e1:SetCost(c90448279.tgcost)
	e1:SetTarget(c90448279.tgtg)
	e1:SetOperation(c90448279.tgop)
	c:RegisterEffect(e1)
	--overlay
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(90448279,2))
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_DESTROYED)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetCondition(c90448279.ovcon)
	e2:SetTarget(c90448279.ovtg)
	e2:SetOperation(c90448279.ovop)
	c:RegisterEffect(e2)
	if not c90448279.global_check then
		c90448279.global_check=true
		local ge1=Effect.GlobalEffect()
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_BATTLED)
		ge1:SetOperation(c90448279.checkop)
		Duel.RegisterEffect(ge1,0)
	end
end
function c90448279.ovfilter(c)
	return c:IsFaceup() and c:IsType(TYPE_XYZ)
end
function c90448279.xyzop(e,tp,chk)
	if chk==0 then return Duel.GetFlagEffect(tp,90448279)>0 and Duel.GetFlagEffect(tp,90448280)==0 end
	Duel.RegisterFlagEffect(tp,90448280,RESET_PHASE+PHASE_END,EFFECT_FLAG_OATH,1)
end
function c90448279.check(c)
	return c and c:IsType(TYPE_XYZ)
end
function c90448279.checkop(e,tp,eg,ep,ev,re,r,rp)
	if c90448279.check(Duel.GetAttacker()) or c90448279.check(Duel.GetAttackTarget()) then
		Duel.RegisterFlagEffect(tp,90448279,RESET_PHASE+PHASE_END,0,1)
		Duel.RegisterFlagEffect(1-tp,90448279,RESET_PHASE+PHASE_END,0,1)
	end
end
function c90448279.tgcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,2,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,2,2,REASON_COST)
end
function c90448279.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,e:GetHandler())
	if chk==0 then return #g>0 end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,g,#g,0,0)
end
function c90448279.tgop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(Card.IsAbleToGrave,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,aux.ExceptThisCard(e))
	if #g>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c90448279.cfilter(c,tp)
	return c:IsPreviousControler(tp) and c:IsPreviousLocation(LOCATION_ONFIELD) and (c:IsReason(REASON_BATTLE) or c:IsReason(REASON_EFFECT) and c:GetReasonPlayer()==1-tp)
end
function c90448279.ovcon(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c90448279.cfilter,1,nil,tp) and not eg:IsContains(e:GetHandler())
end
function c90448279.ofilter(c,e)
	return c:IsCanOverlay() and (not e or not c:IsImmuneToEffect(e))
end
function c90448279.ovtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsType(TYPE_XYZ) and Duel.IsExistingMatchingCard(c90448279.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,nil) end
end
function c90448279.ovop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g=Duel.SelectMatchingCard(tp,c90448279.ofilter,tp,LOCATION_HAND+LOCATION_DECK+LOCATION_EXTRA,0,1,1,nil,e)
		local tc=g:GetFirst()
		if tc then
			Duel.Overlay(c,tc)
		end
		Duel.ShuffleDeck(tp)
	end
end
