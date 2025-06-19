--女神ヴェルダンディの導き
function c64961254.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetCountLimit(1,64961254+EFFECT_COUNT_CODE_OATH)
	e1:SetOperation(c64961254.activate)
	c:RegisterEffect(e1)
	--see top
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH+CATEGORY_SPECIAL_SUMMON+CATEGORY_DECKDES)
	e3:SetDescription(aux.Stringid(64961254,1))
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetCountLimit(1)
	e3:SetRange(LOCATION_SZONE)
	e3:SetTarget(c64961254.target)
	e3:SetOperation(c64961254.operation)
	c:RegisterEffect(e3)
end
function c64961254.thcfilter(c)
	return c:IsFacedown() or not c:IsSetCard(0x122)
end
function c64961254.thcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)>0
		and not Duel.IsExistingMatchingCard(c64961254.thcfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c64961254.thfilter(c)
	return c:IsCode(91969909) and c:IsAbleToHand()
end
function c64961254.activate(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c64961254.thfilter,tp,LOCATION_DECK,0,nil)
	if #g>0 and c64961254.thcon(e,tp,eg,ep,ev,re,r,rp) and
		Duel.SelectYesNo(tp,aux.Stringid(64961254,0)) then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
		local sg=g:Select(tp,1,1,nil)
		Duel.SendtoHand(sg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,sg)
	end
end
function c64961254.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)>0 end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CARDTYPE)
	Duel.SetTargetParam(Duel.AnnounceType(tp))
end
function c64961254.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetFieldGroupCount(tp,0,LOCATION_DECK)<=0 then return end
	Duel.ConfirmDecktop(1-tp,1)
	local g=Duel.GetDecktopGroup(1-tp,1)
	local tc=g:GetFirst()
	Duel.DisableShuffleCheck()
	local opt=Duel.GetChainInfo(0,CHAININFO_TARGET_PARAM)
	if opt==0 and tc:IsType(TYPE_MONSTER)
		and tc:IsCanBeSpecialSummoned(e,0,1-tp,false,false,POS_FACEDOWN_DEFENSE,1-tp) then
		Duel.SpecialSummon(tc,0,1-tp,1-tp,false,false,POS_FACEDOWN_DEFENSE)
	elseif opt==1 and tc:IsType(TYPE_SPELL) and tc:IsSSetable() then
		Duel.SSet(1-tp,tc)
	elseif opt==2 and tc:IsType(TYPE_TRAP) and tc:IsSSetable() then
		Duel.SSet(1-tp,tc)
	else
		Duel.SendtoHand(g,1-tp,REASON_EFFECT)
		Duel.ShuffleHand(1-tp)
	end
end
