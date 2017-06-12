--エルシャドール・ネフィリム
function c20366274.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c20366274.fuscon)
	e1:SetOperation(c20366274.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c20366274.splimit)
	c:RegisterEffect(e2)
	--tograve
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(20366274,0))
	e3:SetCategory(CATEGORY_TOGRAVE)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_SPSUMMON_SUCCESS)
	e3:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e3:SetTarget(c20366274.tgtg)
	e3:SetOperation(c20366274.tgop)
	c:RegisterEffect(e3)
	--destroy
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(20366274,1))
	e4:SetCategory(CATEGORY_DESTROY)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e4:SetCode(EVENT_BATTLE_START)
	e4:SetCondition(c20366274.descon)
	e4:SetTarget(c20366274.destg)
	e4:SetOperation(c20366274.desop)
	c:RegisterEffect(e4)
	--tohand
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(20366274,2))
	e5:SetCategory(CATEGORY_TOHAND)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_TO_GRAVE)
	e5:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e5:SetTarget(c20366274.thtg)
	e5:SetOperation(c20366274.thop)
	c:RegisterEffect(e5)
end
function c20366274.ffilter(c,fc)
	return (c20366274.ffilter1(c) or c20366274.ffilter2(c)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c20366274.exfilter(c,fc)
	return c:IsFaceup() and c20366274.ffilter(c,fc)
end
function c20366274.ffilter1(c)
	return c:IsFusionSetCard(0x9d)
end
function c20366274.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_LIGHT) or c:IsHasEffect(4904633)
end
function c20366274.spfilter1(c,tp,mg,exg)
	return mg:IsExists(c20366274.spfilter2,1,c,tp,c) or (exg and exg:IsExists(c20366274.spfilter2,1,c,tp,c))
end
function c20366274.spfilter2(c,tp,mc)
	return (c20366274.ffilter1(c) and c20366274.ffilter2(mc)
		or c20366274.ffilter2(c) and c20366274.ffilter1(mc))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c20366274.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local mg=g:Filter(c20366274.ffilter,nil,c)
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c20366274.exfilter,tp,0,LOCATION_MZONE,mg,c)
	end
	if gc then
		if not mg:IsContains(gc) then return false end
		return c20366274.spfilter1(gc,tp,mg,exg)
	end
	return mg:IsExists(c20366274.spfilter1,1,nil,tp,mg,exg)
end
function c20366274.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(c20366274.ffilter,nil,c)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c20366274.exfilter,tp,0,LOCATION_MZONE,mg,c)
	end
	local g=nil
	if gc then
		g=Group.FromCards(gc)
		mg:RemoveCard(gc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=mg:FilterSelect(tp,c20366274.spfilter1,1,1,nil,tp,mg,exg)
		mg:Sub(g)
	end
	if exg and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=exg:FilterSelect(tp,c20366274.spfilter2,1,1,nil,tp,g:GetFirst())
		g:Merge(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:FilterSelect(tp,c20366274.spfilter2,1,1,nil,tp,g:GetFirst())
		g:Merge(sg)
	end
	Duel.SetFusionMaterial(g)
end
function c20366274.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c20366274.tgfilter(c)
	return c:IsSetCard(0x9d) and c:IsAbleToGrave()
end
function c20366274.tgtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c20366274.tgfilter,tp,LOCATION_DECK,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOGRAVE,nil,1,tp,LOCATION_DECK)
end
function c20366274.tgop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TOGRAVE)
	local g=Duel.SelectMatchingCard(tp,c20366274.tgfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then
		Duel.SendtoGrave(g,REASON_EFFECT)
	end
end
function c20366274.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local bc=c:GetBattleTarget()
	return bc and bc:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c20366274.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,e:GetHandler():GetBattleTarget(),1,0,0)
end
function c20366274.desop(e,tp,eg,ep,ev,re,r,rp)
	local bc=e:GetHandler():GetBattleTarget()
	if bc:IsRelateToBattle() then
		Duel.Destroy(bc,REASON_EFFECT)
	end
end
function c20366274.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c20366274.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c20366274.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c20366274.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c20366274.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c20366274.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
