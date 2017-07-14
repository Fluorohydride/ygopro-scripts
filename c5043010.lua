--ファイアウォール・ドラゴン
function c5043010.initial_effect(c)
	--link summon
	aux.AddLinkProcedure(c,nil,2)
	c:EnableReviveLimit()
	--to hand
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(5043010,0))
	e1:SetCategory(CATEGORY_TOHAND)
	e1:SetType(EFFECT_TYPE_QUICK_O)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_NO_TURN_RESET)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetHintTiming(0,0x1e0)
	e1:SetTarget(c5043010.thtg)
	e1:SetOperation(c5043010.thop)
	c:RegisterEffect(e1)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_LEAVE_FIELD_P)
	e2:SetOperation(c5043010.regop)
	c:RegisterEffect(e2)
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(5043010,1))
	e3:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e3:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP)
	e3:SetCode(EVENT_BATTLE_DESTROYED)
	e3:SetRange(LOCATION_MZONE)
	e3:SetLabelObject(e2)
	e3:SetCondition(c5043010.spcon)
	e3:SetTarget(c5043010.sptg)
	e3:SetOperation(c5043010.spop)
	c:RegisterEffect(e3)
	local e4=e3:Clone()
	e4:SetCode(EVENT_TO_GRAVE)
	c:RegisterEffect(e4)
	local e5=e2:Clone()
	e5:SetCode(EVENT_BE_PRE_MATERIAL)
	e5:SetOperation(c5043010.regop2)
	e5:SetLabelObject(e2)
	c:RegisterEffect(e5)
	--
	if not Card.GetMutualLinkedGroup then
		function aux.mutuallinkfilter(c,mc)
			local lg=c:GetLinkedGroup()
			return lg and lg:IsContains(mc)
		end
		function Card.GetMutualLinkedGroup(c)
			local lg=c:GetLinkedGroup()
			if not lg then return nil end
			return lg:Filter(aux.mutuallinkfilter,nil,c)
		end
		function Card.GetMutualLinkedCount(c)
			local lg=c:GetLinkedGroup()
			if not lg then return 0 end
			return lg:FilterCount(aux.mutuallinkfilter,nil,c)
		end
	end
end
function c5043010.thfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsAbleToHand()
end
function c5043010.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	local ct=c:GetMutualLinkedCount()
	if chkc then return chkc:IsLocation(LOCATION_MZONE+LOCATION_GRAVE) and c5043010.thfilter(chkc) end
	if chk==0 then return ct>0 and Duel.IsExistingTarget(c5043010.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_RTOHAND)
	local g=Duel.SelectTarget(tp,c5043010.thfilter,tp,LOCATION_MZONE+LOCATION_GRAVE,LOCATION_MZONE+LOCATION_GRAVE,1,ct,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,g:GetCount(),0,0)
	c:RegisterFlagEffect(0,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CLIENT_HINT,1,0,aux.Stringid(5043010,2))
end
function c5043010.thop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetChainInfo(0,CHAININFO_TARGET_CARDS):Filter(Card.IsRelateToEffect,nil,e)
	Duel.SendtoHand(g,nil,REASON_EFFECT)
end
function c5043010.regop(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local lg=g:Clone()
	lg:KeepAlive()
	e:SetLabelObject(lg)
end
function c5043010.regop2(e,tp,eg,ep,ev,re,r,rp)
	local g=e:GetHandler():GetLinkedGroup()
	if not g then return end
	local lg=g:Clone()
	lg:KeepAlive()
	e:GetLabelObject():SetLabelObject(lg)
end
function c5043010.cfilter(c,g)
	return g:IsContains(c)
end
function c5043010.spcon(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetLabelObject():GetLabelObject()
	if not lg then return false end
	return eg:IsExists(c5043010.cfilter,1,nil,lg)
end
function c5043010.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,nil,e,0,tp,false,false) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_HAND)
end
function c5043010.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,Card.IsCanBeSpecialSummoned,tp,LOCATION_HAND,0,1,1,nil,e,0,tp,false,false)
	if g:GetCount()>0 then
		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
	end
end
