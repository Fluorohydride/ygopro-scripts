--アカシック・マジシャン
function c28776350.initial_effect(c)
	c:EnableReviveLimit()
	--link summon
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(c28776350.lkcon)
	e0:SetOperation(c28776350.lkop)
	e0:SetValue(SUMMON_TYPE_LINK)
	c:RegisterEffect(e0)
	--splimit
	local e1=Effect.CreateEffect(c)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e1:SetCode(EVENT_SPSUMMON_SUCCESS)
	e1:SetCondition(c28776350.regcon)
	e1:SetOperation(c28776350.regop)
	c:RegisterEffect(e1)
	--to hand
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(28776350,0))
	e2:SetCategory(CATEGORY_TOHAND)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetCondition(c28776350.thcon)
	e2:SetTarget(c28776350.thtg)
	e2:SetOperation(c28776350.thop)
	c:RegisterEffect(e2)
	--announce
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(28776350,1))
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_DECKDES)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCountLimit(1)
	e3:SetTarget(c28776350.actg)
	e3:SetOperation(c28776350.acop)
	c:RegisterEffect(e3)
end
function c28776350.regcon(e,tp,eg,ep,ev,re,r,rp)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c28776350.regop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_SPECIAL_SUMMON)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetTargetRange(1,0)
	e1:SetReset(RESET_PHASE+PHASE_END)
	e1:SetTarget(c28776350.splimit)
	Duel.RegisterEffect(e1,tp)
end
function c28776350.splimit(e,c,sump,sumtype,sumpos,targetp,se)
	return c:IsCode(28776350) and bit.band(sumtype,SUMMON_TYPE_LINK)==SUMMON_TYPE_LINK
end
function c28776350.lkfilter1(c,lc,tp)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and not c:IsLinkType(TYPE_TOKEN) and Duel.IsExistingMatchingCard(c28776350.lkfilter2,tp,LOCATION_MZONE,0,1,c,lc,c,tp)
end
function c28776350.lkfilter2(c,lc,mc,tp)
	local mg=Group.FromCards(c,mc)
	return c:IsFaceup() and c:IsCanBeLinkMaterial(lc) and c:IsRace(mc:GetRace()) and not c:IsLinkType(TYPE_TOKEN) and Duel.GetLocationCountFromEx(tp,tp,mg,lc)>0
end
function c28776350.lkcon(e,c)
	if c==nil then return true end
	if c:IsType(TYPE_PENDULUM) and c:IsFaceup() then return false end
	local tp=c:GetControler()
	return Duel.IsExistingMatchingCard(c28776350.lkfilter1,tp,LOCATION_MZONE,0,1,nil,c,tp)
end
function c28776350.lkop(e,tp,eg,ep,ev,re,r,rp,c)
	local g1=Duel.SelectMatchingCard(tp,c28776350.lkfilter1,tp,LOCATION_MZONE,0,1,1,nil,c,tp)
	local g2=Duel.SelectMatchingCard(tp,c28776350.lkfilter2,tp,LOCATION_MZONE,0,1,1,g1:GetFirst(),c,g1:GetFirst(),tp)
	g1:Merge(g2)
	c:SetMaterial(g1)
	Duel.SendtoGrave(g1,REASON_MATERIAL+REASON_LINK)
end
function c28776350.thcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsSummonType(SUMMON_TYPE_LINK)
end
function c28776350.thtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,lg,lg:GetCount(),0,0)
end
function c28776350.thop(e,tp,eg,ep,ev,re,r,rp)
	local lg=e:GetHandler():GetLinkedGroup():Filter(Card.IsAbleToHand,nil)
	Duel.SendtoHand(lg,nil,REASON_EFFECT)
end
function c28776350.actg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local c=e:GetHandler()
		local lg=c:GetMutualLinkedGroup()
		local ct=lg:GetSum(Card.GetLink)
		if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,ct) then return false end
		local g=Duel.GetDecktopGroup(tp,ct)
		return g:FilterCount(Card.IsAbleToHand,nil)>0
	end
	Duel.Hint(HINT_SELECTMSG,tp,564)
	c28776350.announce_filter={TYPE_FUSION+TYPE_SYNCHRO+TYPE_XYZ+TYPE_LINK,OPCODE_ISTYPE,OPCODE_NOT}
	local ac=Duel.AnnounceCardFilter(tp,table.unpack(c28776350.announce_filter))
	Duel.SetTargetParam(ac)
	Duel.SetOperationInfo(0,CATEGORY_ANNOUNCE,nil,0,tp,ANNOUNCE_CARD)
end
function c28776350.thfilter(c,code)
	return c:IsCode(code) and c:IsAbleToHand()
end
function c28776350.acop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local lg=c:GetMutualLinkedGroup()
	local ct=lg:GetSum(Card.GetLink)
	if ct<=0 or not Duel.IsPlayerCanDiscardDeck(tp,ct) then return end
	Duel.ConfirmDecktop(tp,ct)
	local g=Duel.GetDecktopGroup(tp,ct)
	local ac=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	local hg=g:Filter(c28776350.thfilter,nil,ac)
	g:Sub(hg)
	if hg:GetCount()~=0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoHand(hg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,hg)
		Duel.ShuffleHand(tp)
	end
	if g:GetCount()~=0 then
		Duel.DisableShuffleCheck()
		Duel.SendtoGrave(g,REASON_EFFECT+REASON_REVEAL)
	end
end
