--エルシャドール・ウェンディゴ
function c74009824.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c74009824.fuscon)
	e1:SetOperation(c74009824.fusop)
	c:RegisterEffect(e1)
	--cannot spsummon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetProperty(EFFECT_FLAG_SINGLE_RANGE+EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetValue(c74009824.splimit)
	c:RegisterEffect(e2)
	--indes
	local e3=Effect.CreateEffect(c)
	e3:SetDescription(aux.Stringid(74009824,0))
	e3:SetType(EFFECT_TYPE_QUICK_O)
	e3:SetCode(EVENT_FREE_CHAIN)
	e3:SetRange(LOCATION_MZONE)
	e3:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e3:SetCountLimit(1,74009824)
	e3:SetTarget(c74009824.indtg)
	e3:SetOperation(c74009824.indop)
	c:RegisterEffect(e3)
	--tohand
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(74009824,1))
	e4:SetCategory(CATEGORY_TOHAND)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_TO_GRAVE)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e4:SetTarget(c74009824.thtg)
	e4:SetOperation(c74009824.thop)
	c:RegisterEffect(e4)
end
function c74009824.ffilter(c,fc)
	return (c74009824.ffilter1(c) or c74009824.ffilter2(c)) and c:IsCanBeFusionMaterial(fc) and not c:IsHasEffect(6205579)
end
function c74009824.exfilter(c,fc)
	return c:IsFaceup() and c74009824.ffilter(c,fc)
end
function c74009824.ffilter1(c)
	return c:IsFusionSetCard(0x9d)
end
function c74009824.ffilter2(c)
	return c:IsFusionAttribute(ATTRIBUTE_WIND) or c:IsHasEffect(4904633)
end
function c74009824.spfilter1(c,tp,mg,exg)
	return mg:IsExists(c74009824.spfilter2,1,c,tp,c) or (exg and exg:IsExists(c74009824.spfilter2,1,c,tp,c))
end
function c74009824.spfilter2(c,tp,mc)
	return (c74009824.ffilter1(c) and c74009824.ffilter2(mc)
		or c74009824.ffilter2(c) and c74009824.ffilter1(mc))
		and Duel.GetLocationCountFromEx(tp,tp,Group.FromCards(c,mc))>0
end
function c74009824.fuscon(e,g,gc,chkf)
	if g==nil then return true end
	local c=e:GetHandler()
	local mg=g:Filter(c74009824.ffilter,nil,c)
	local tp=e:GetHandlerPlayer()
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c74009824.exfilter,tp,0,LOCATION_MZONE,mg,c)
	end
	if gc then
		if not mg:IsContains(gc) then return false end
		return c74009824.spfilter1(gc,tp,mg,exg)
	end
	return mg:IsExists(c74009824.spfilter1,1,nil,tp,mg,exg)
end
function c74009824.fusop(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local c=e:GetHandler()
	local mg=eg:Filter(c74009824.ffilter,nil,c)
	local fc=Duel.GetFieldCard(tp,LOCATION_SZONE,5)
	local exg=nil
	if fc and fc:IsHasEffect(81788994) and fc:IsCanRemoveCounter(tp,0x16,3,REASON_EFFECT) then
		exg=Duel.GetMatchingGroup(c74009824.exfilter,tp,0,LOCATION_MZONE,mg,c)
	end
	local g=nil
	if gc then
		g=Group.FromCards(gc)
		mg:RemoveCard(gc)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g=mg:FilterSelect(tp,c74009824.spfilter1,1,1,nil,tp,mg,exg)
		mg:Sub(g)
	end
	if exg and (mg:GetCount()==0 or (exg:GetCount()>0 and Duel.SelectYesNo(tp,aux.Stringid(81788994,0)))) then
		fc:RemoveCounter(tp,0x16,3,REASON_EFFECT)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=exg:FilterSelect(tp,c74009824.spfilter2,1,1,nil,tp,g:GetFirst())
		g:Merge(sg)
	else
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local sg=mg:FilterSelect(tp,c74009824.spfilter2,1,1,nil,tp,g:GetFirst())
		g:Merge(sg)
	end
	Duel.SetFusionMaterial(g)
end
function c74009824.splimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function c74009824.indtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) end
	if chk==0 then return Duel.IsExistingTarget(nil,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_TARGET)
	Duel.SelectTarget(tp,nil,tp,LOCATION_MZONE,0,1,1,nil)
end
function c74009824.indop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(c74009824.indval)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
	end
end
function c74009824.indval(e,c)
	return c:IsSummonType(SUMMON_TYPE_SPECIAL)
end
function c74009824.thfilter(c)
	return c:IsSetCard(0x9d) and c:IsType(TYPE_SPELL+TYPE_TRAP) and c:IsAbleToHand()
end
function c74009824.thtg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c74009824.thfilter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c74009824.thfilter,tp,LOCATION_GRAVE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectTarget(tp,c74009824.thfilter,tp,LOCATION_GRAVE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,g,1,0,0)
end
function c74009824.thop(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) then
		Duel.SendtoHand(tc,nil,REASON_EFFECT)
	end
end
